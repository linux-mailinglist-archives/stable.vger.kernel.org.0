Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039DD2518C4
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 14:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgHYMoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 08:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbgHYMoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 08:44:18 -0400
Received: from mail.kmu-office.ch (mail.kmu-office.ch [IPv6:2a02:418:6a02::a2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674F5C061574;
        Tue, 25 Aug 2020 05:44:18 -0700 (PDT)
Received: from webmail.kmu-office.ch (unknown [IPv6:2a02:418:6a02::a3])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id D69115C234A;
        Tue, 25 Aug 2020 14:44:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1598359451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8IZQHFETOpjnhPeM+CTUxB0PCC3vGiT/h25l4mGED5A=;
        b=kV5mTYPL00hXKtDehuNlhVBXVoopFZyBR32wotpKs0Uf2t6AsDgRbzxmLqhCdaXDsPW8iY
        OF+84r6uLjz1jnXn+o57uSxkY+XU6pE/dL6ssjSUnxZsyp7sObDV9yjoVyVQoL1v5gni+T
        lz2PILM5rKaWpQ4fkivJ88xE9JVIXGA=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date:   Tue, 25 Aug 2020 14:44:11 +0200
From:   Stefan Agner <stefan@agner.ch>
To:     Chris Healy <cphealy@gmail.com>
Cc:     srinivas.kandagatla@linaro.org, robh+dt@kernel.org,
        gregkh@linuxfoundation.org, maitysanchayan@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, festevam@gmail.com, stable@vger.kernel.org,
        andrew.smirnov@gmail.com
Subject: Re: [PATCH v4] dt-bindings: nvmem: Add syscon to Vybrid OCOTP driver
In-Reply-To: <20200825030406.373623-1-cphealy@gmail.com>
References: <20200825030406.373623-1-cphealy@gmail.com>
User-Agent: Roundcube Webmail/1.4.1
Message-ID: <a0a1958d393eb92ecc884be7a0dc0449@agner.ch>
X-Sender: stefan@agner.ch
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-25 05:04, Chris Healy wrote:
> From: Chris Healy <cphealy@gmail.com>
> 
> Add syscon compatibility with Vybrid OCOTP driver binding. This is
> required to access the UID.
> 
> Fixes: 623069946952 ("nvmem: Add DT binding documentation for Vybrid
> OCOTP driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Healy <cphealy@gmail.com>

Reviewed-by: Stefan Agner <stefan@agner.ch>

> ---
> Changes in v4:
>  - Point to the appropriate commit for the Fixes: line
>  - Update the Required Properties to add the "syscon" compatible
> ---
>  Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt
> b/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt
> index 56ed481c3e26..72ba628f6d0b 100644
> --- a/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt
> +++ b/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt
> @@ -2,7 +2,7 @@ On-Chip OTP Memory for Freescale Vybrid
>  
>  Required Properties:
>    compatible:
> -  - "fsl,vf610-ocotp" for VF5xx/VF6xx
> +  - "fsl,vf610-ocotp", "syscon" for VF5xx/VF6xx
>    #address-cells : Should be 1
>    #size-cells : Should be 1
>    reg : Address and length of OTP controller and fuse map registers
> @@ -11,7 +11,7 @@ Required Properties:
>  Example for Vybrid VF5xx/VF6xx:
>  
>  	ocotp: ocotp@400a5000 {
> -		compatible = "fsl,vf610-ocotp";
> +		compatible = "fsl,vf610-ocotp", "syscon";
>  		#address-cells = <1>;
>  		#size-cells = <1>;
>  		reg = <0x400a5000 0xCF0>;
