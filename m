Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD73186589
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 08:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbgCPHWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 03:22:02 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45119 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbgCPHWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 03:22:02 -0400
Received: by mail-lf1-f68.google.com with SMTP id b13so13060897lfb.12;
        Mon, 16 Mar 2020 00:22:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I7aBKCm8kI2F7Jl47saMU25REPiGQ5/LzV7PSFh0a9E=;
        b=KpJtAVtEBJYrb78D+ga2nTcPCCk5TP99+D/E9xzopC2WSx4Ct5Fd9iKQ4+4I7nbBOy
         vOaFw1uA8ummW8s4gaGNaKgsltXr7lQ57c57OukkqnssfDqNjKcxKSz0NmkHUR1hTfzb
         nlCTAnkarBvaCGEaFx4xDWzPfaP0O7vfzmhGG/2RMA6WlA3ikUCDupF5jnQajP9oufw4
         TRItRdKvgmyeEiTmXivj2RSfWlgpL5KMhBImErzwMXP7QWQMeV1E4J/1EWzYI4ghtbzP
         YqQMPakHZj/nDpy9X9fynFG/6sRae7iqH90u2bGXcY1uDovXZvyu0NKP5Ce7BRL1bYAR
         WK8w==
X-Gm-Message-State: ANhLgQ0ZaeGCO5bB/4wvTmWMQlw6TF5rDQxsc0EVMyvD1ut4XpQ7XFxB
        x2kThUDHcLbP6m3euPB9cMzaIg3c
X-Google-Smtp-Source: ADFU+vvfXaI0eA6zxF80cwGW+BpzLifqbMXqRzCrqipFgyDI9intGbzRrLSOburBVMZ/TzFxex69dw==
X-Received: by 2002:a19:6f44:: with SMTP id n4mr16199861lfk.59.1584343320572;
        Mon, 16 Mar 2020 00:22:00 -0700 (PDT)
Received: from xi.terra (c-12aae455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.170.18])
        by smtp.gmail.com with ESMTPSA id a10sm14618994ljb.23.2020.03.16.00.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 00:21:59 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1jDk4F-0002Bi-58; Mon, 16 Mar 2020 08:21:43 +0100
Date:   Mon, 16 Mar 2020 08:21:43 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Sanchayan Maity <maitysanchayan@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.5 05/41] ARM: dts: imx6dl-colibri-eval-v3: fix
 sram compatible properties
Message-ID: <20200316072143.GT14211@localhost>
References: <20200316023319.749-1-sashal@kernel.org>
 <20200316023319.749-5-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316023319.749-5-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 15, 2020 at 10:32:43PM -0400, Sasha Levin wrote:
> From: Johan Hovold <johan@kernel.org>
> 
> [ Upstream commit bcbf53a0dab50980867476994f6079c1ec5bb3a3 ]
> 
> The sram-node compatible properties have mistakingly combined the
> model-specific string with the generic "mtd-ram" string.
> 
> Note that neither "cy7c1019dv33-10zsxi, mtd-ram" or
> "cy7c1019dv33-10zsxi" are used by any in-kernel driver and they are
> not present in any binding.
> 
> The physmap driver will however bind to platform devices that specify
> "mtd-ram".
> 
> Fixes: fc48e76489fd ("ARM: dts: imx6: Add support for Toradex Colibri iMX6 module")
> Cc: Sanchayan Maity <maitysanchayan@gmail.com>
> Cc: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> Cc: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Reviewed-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Greg has already dropped this one from the stable queues once on my
request, so please do not add it back.

Johan
