Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F7D24EB05
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 05:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgHWDMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 23:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgHWDMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Aug 2020 23:12:41 -0400
Received: from dragon (unknown [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60C882078A;
        Sun, 23 Aug 2020 03:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598152361;
        bh=OgDCfotVCHJ/iPOc2g7NKza30Z+lOaNbXLiULAikxeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uGOkTjbb+Yu3HZw4XPi3ywRULRA80mApub28t6dgFUaRUEyARpJUA8/1s5fWK5fye
         yCp+a9bkm5cR0wPo8Xl2ILYB1C0weI1Reoh+EkLVu3pRok+qoHdjHDFt7+wSX67Dzs
         yF7ftj3Vb46ksy+wla4lnSYdCmB8l6T1BsImYY+Q=
Date:   Sun, 23 Aug 2020 11:12:28 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Chris Healy <cphealy@gmail.com>
Cc:     srinivas.kandagatla@linaro.org, robh+dt@kernel.org,
        andrew.smirnov@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, s.hauer@pengutronix.de,
        kernel@pengutronix.de, stefan@agner.ch,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        festevam@gmail.com
Subject: Re: [PATCH v3 1/2] dt-bindings: nvmem: Add syscon to Vybrid OCOTP
 driver
Message-ID: <20200823031227.GT30094@dragon>
References: <20200821212102.137991-1-cphealy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821212102.137991-1-cphealy@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 02:21:01PM -0700, Chris Healy wrote:
> From: Chris Healy <cphealy@gmail.com>
> 
> Add syscon compatibility with Vybrid OCOTP driver binding. This is
> required to access the UID.
> 
> Fixes: fa8d20c8dbb77 ("ARM: dts: vfxxx: Add node corresponding to OCOTP")

The bindings doc was not added by this commit though.

> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Healy <cphealy@gmail.com>
> ---
>  Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt b/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt
> index 56ed481c3e26..5db39f399568 100644
> --- a/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt
> +++ b/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt
> @@ -11,7 +11,7 @@ Required Properties:
>  Example for Vybrid VF5xx/VF6xx:
>  
>  	ocotp: ocotp@400a5000 {
> -		compatible = "fsl,vf610-ocotp";
> +		compatible = "fsl,vf610-ocotp", "syscon";

It's not only about fixing example.  More important one is "compatible"
property of the bindings.

Shawn

>  		#address-cells = <1>;
>  		#size-cells = <1>;
>  		reg = <0x400a5000 0xCF0>;
> -- 
> 2.26.2
> 
