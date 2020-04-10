Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 888B71A425C
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 08:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgDJGHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 02:07:14 -0400
Received: from gofer.mess.org ([88.97.38.141]:57043 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgDJGHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Apr 2020 02:07:13 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 49514C63A8; Fri, 10 Apr 2020 07:07:12 +0100 (BST)
Date:   Fri, 10 Apr 2020 07:07:12 +0100
From:   Sean Young <sean@mess.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mohammad Rasim <mohammad.rasim96@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.6 11/68] media: arm64: dts: amlogic: add
 rc-videostrong-kii-pro keymap
Message-ID: <20200410060712.GA13759@gofer.mess.org>
References: <20200410034634.7731-1-sashal@kernel.org>
 <20200410034634.7731-11-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410034634.7731-11-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 09, 2020 at 11:45:36PM -0400, Sasha Levin wrote:
> From: Mohammad Rasim <mohammad.rasim96@gmail.com>
> 
> [ Upstream commit 806d06161af045dba29f3c7747550c93b2ea3ca9 ]
> 
> videostrong kii pro comes with a nec rc, add the keymap to the dts
> 
> Signed-off-by: Mohammad Rasim <mohammad.rasim96@gmail.com>
> Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
> Signed-off-by: Sean Young <sean@mess.org>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
> index 2f1f829450a29..6c9cc45fb417e 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
> @@ -76,3 +76,7 @@
>  		};
>  	};
>  };
> +
> +&ir {
> +	linux,rc-map-name = "rc-videostrong-kii-pro";
> +};

The will need the keymap itself as well. It was added in commit
30defecb98400575349a7d32f0526e1dc42ea83e.


Sean
