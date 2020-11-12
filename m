Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDB02B0536
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 13:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgKLMws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 07:52:48 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7638 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728178AbgKLMwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 07:52:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad301f0002>; Thu, 12 Nov 2020 04:52:47 -0800
Received: from [10.26.72.124] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 12:52:41 +0000
Subject: Re: [PATCH] ARM: tegra: Populate OPP table for Tegra20 Ventana
To:     Dmitry Osipenko <digetx@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20201111103847.152721-1-jonathanh@nvidia.com>
 <ea73403a-a248-cd2e-b0af-aeb246801054@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9adf5175-d77b-5a50-8cb3-18305582a57b@nvidia.com>
Date:   Thu, 12 Nov 2020 12:52:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ea73403a-a248-cd2e-b0af-aeb246801054@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605185567; bh=8DfHoZREZ/l0HtR64GiqLrX+xk3X9RCijo+BL6PuSZk=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=Gs/gWqN11KclIRM9X4ObMAlFz3tDXrxihkTR3fzZWiaANV0S8BQcs91k3yVZGSDli
         NTuR3paPm6MifiqdrSlZlawcrjZkkhtNkxrY4/9kUE+iuGhZcDUq7OYmGaTt7Kw+Z8
         /5TjAZCuwujpWAPvsP7kSOXsaEtc76BDS3e+LVM8ZQl3QDLoOlbkTKgs7Oq6M5Jj1v
         RHybgVu7qi0V7YqU6f45Xclz4aVPyl9vGvIEp7WFr4WAF3fdEbfiOqeTYvnPYOj1BK
         WOAr3tpdpIEfZTxI+pzpiM4yBZZsOa445G5FWQ/6imyUgqwO9n+L6UoeJ3K4aRj7na
         z4JzPahp6q96A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/11/2020 12:11, Dmitry Osipenko wrote:
> 11.11.2020 13:38, Jon Hunter =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> Commit 9ce274630495 ("cpufreq: tegra20: Use generic cpufreq-dt driver
>> (Tegra30 supported now)") update the Tegra20 CPUFREQ driver to use the
>> generic CPUFREQ device-tree driver. Since this change CPUFREQ support
>> on the Tegra20 Ventana platform has been broken because the necessary
>> device-tree nodes with the operating point information are not populated
>> for this platform. Fix this by updating device-tree for Venata to
>> include the operating point informration for Tegra20.
>>
>> Fixes: 9ce274630495 ("cpufreq: tegra20: Use generic cpufreq-dt driver (T=
egra30 supported now)")
>> Cc: stable@vger.kernel.org
>>
>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
>> ---
>>  arch/arm/boot/dts/tegra20-ventana.dts | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/t=
egra20-ventana.dts
>> index b158771ac0b7..055334ae3d28 100644
>> --- a/arch/arm/boot/dts/tegra20-ventana.dts
>> +++ b/arch/arm/boot/dts/tegra20-ventana.dts
>> @@ -3,6 +3,7 @@
>> =20
>>  #include <dt-bindings/input/input.h>
>>  #include "tegra20.dtsi"
>> +#include "tegra20-cpu-opp.dtsi"
>> =20
>>  / {
>>  	model =3D "NVIDIA Tegra20 Ventana evaluation board";
>> @@ -592,6 +593,16 @@ clk32k_in: clock@0 {
>>  		#clock-cells =3D <0>;
>>  	};
>> =20
>> +	cpus {
>> +		cpu0: cpu@0 {
>=20
> I assume you're going to use this cpu0 handle later on.

Opps, I will remove that.

>=20
>> +			operating-points-v2 =3D <&cpu0_opp_table>;
>> +		};
>> +
>> +		cpu@1 {
>> +			operating-points-v2 =3D <&cpu0_opp_table>;
>> +		};
>> +	};
>> +
>>  	gpio-keys {
>>  		compatible =3D "gpio-keys";
>> =20
>>
>=20
> Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
>=20

Thanks!
Jon

--=20
nvpublic
