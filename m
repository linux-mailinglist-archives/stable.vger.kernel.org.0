Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565DA69576F
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 04:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjBND1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 22:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbjBND1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 22:27:16 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A221C333
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 19:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676345234; x=1707881234;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C2DX287fihxIx3zZ1XYsGz3AZwndKdwrpwX0k0QUAWQ=;
  b=npW4Gpll8weHnzDKqIWEY6yMYNMbFeMD5f8d/wDYT3UcTWZ97ZevvIbQ
   MDt6wn8qhN3u/ucp8vMnXYhvXAOvtmeMfXKDZwk3Q8L5OfQhsnZKkYlFD
   OU8VsQ40llP3ZT7KkTYDthJJ0SVYhzIsJZ35tgUSWF7cgNGaHlxe45Q5J
   8LKu2UfPaX6jnwourEVnX8AxJhSjS+qlA7gfgQl+CVkww9qP8AJf9NMUf
   e6izvXv8KL/AoJXyjkIzb29t6e6vYbmW7qyOxbWRgt/I9vl6fwOmdqNmI
   63a4X3dLW2nz9ToPmFQRwoT+JGNath0078KzH6e0i3EPnNuyehKvq1o1i
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669046400"; 
   d="scan'208";a="221534004"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2023 11:27:12 +0800
IronPort-SDR: OmCvh3sA3gQ7id6Nc0z3GRdyJktd8TX0F/PixgyHFBKeJeVR72gKjAB7laEnExojsHdamft+iz
 O5mQhmx8PP94vR9MTCvvtvmSFDr8Ld0s93Yd6NafCwZZR23N51bUA1iecB/69yTx7WyZ8EPiGb
 kh+HcE35GmN1fJoBGlPhV2xDWv+qeBWuZVCLNJs9VRc3a5z3Fzbjv9lRgAmOnITBpM74U3v2Xq
 96D5ZQXi2LicwQ/c5O8oiNGmaHLm5NJjCP+xgEdbkyr4WbmegXxRXXIJIU1uKYh9tNSylyOhmc
 0dY=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Feb 2023 18:44:20 -0800
IronPort-SDR: YVJmNfFDToBb92IRrmXZdg+7AbdZXUgiKeeox8V9cfGicADrEfRmWo0vxm5AqsZUK+HvqSHcaL
 XNYaLdOLwDRAVLrT0XYhjvh4r8bwYwNxOriyaIcbFgXzVVtc/ksbZXJ0syiB56f81/UoTJkzoP
 NEQjgI5fRYXmHO8dQog8ZShVL2LDzsX976VAgY4HT0wmdPiaANUaW5s1JdTdAxEvuAHQ6uZ3r1
 UcguNOwP/8erQ5FMmRL6l/PbC5IoLScgV8lX6PvJJr0pTtwqANFPjsMoPNjlQh3YZwktQZEi4m
 S/c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Feb 2023 19:27:13 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PG68J2lc9z1RwqL
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 19:27:12 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1676345231; x=1678937232; bh=C2DX287fihxIx3zZ1XYsGz3AZwndKdwrpwX
        0k0QUAWQ=; b=njZNJbQ5di5LnVdvp1bpA7hocbJUDtSzeOAyiShtGuoRSppSJ5L
        OH8eXe//apqqv8YlltI89f4HIg2p//HQpsCtaz/88vA3zxaY6Y6i/sqtd1121C5B
        Tf6PVZ9BrGzKNJxVDyG7fZQrHNkPjunDhHT7fom3nWduwMxB4/jB7tDhgpI30341
        YR0kOifWPV4AGcyqxxP8LmKwZZW1zvdx86U58e+30aIFv4kiiXT3E+BYaNc79TLE
        diDUONFdl0Tn1FcdzsOteakeMIyLMhvSgTfXuhztjB8FY0d5dFjZSpXHc8/+rAFx
        XRZQc2bFXqpJRlevmjqV3OxLIjIRJ4fjeew==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id sTWDGTZv7F_o for <stable@vger.kernel.org>;
        Mon, 13 Feb 2023 19:27:11 -0800 (PST)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PG68G4SGXz1RvLy;
        Mon, 13 Feb 2023 19:27:10 -0800 (PST)
Message-ID: <f67adf9f-2fa1-efed-afa8-04c5149a23ca@opensource.wdc.com>
Date:   Tue, 14 Feb 2023 12:27:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] ata: ahci: Add Tiger Lake UP{3,4} AHCI controller
Content-Language: en-US
To:     Simon Gaiser <simon@invisiblethingslab.com>
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230213102450.1604-1-simon@invisiblethingslab.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230213102450.1604-1-simon@invisiblethingslab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/23 19:24, Simon Gaiser wrote:
> Mark the Tiger Lake UP{3,4} AHCI controller as "low_power". This enables
> S0ix to work out of the box. Otherwise this isn't working unless the
> user manually sets /sys/class/scsi_host/*/link_power_management_policy.
> 
> Intel lists a total of 4 SATA controller IDs in [1] for those mobile
> PCHs. This commit just adds the "AHCI" variant since I only tested
> those.
> 
> [1]: https://cdrdv2.intel.com/v1/dl/getContent/631119
> 
> Signed-off-by: Simon Gaiser <simon@invisiblethingslab.com>
> CC: stable@vger.kernel.org

Applied to for-6.2-fixes. Thanks !

-- 
Damien Le Moal
Western Digital Research

