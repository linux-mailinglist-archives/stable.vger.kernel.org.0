Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1701436AA31
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 03:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhDZBId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 21:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhDZBIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Apr 2021 21:08:32 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED7DC061574
        for <stable@vger.kernel.org>; Sun, 25 Apr 2021 18:07:50 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id l22so54731287ljc.9
        for <stable@vger.kernel.org>; Sun, 25 Apr 2021 18:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XKYDend4fR4Ns4FQUvGIkyd1mejjx00DHoiaI53DpUk=;
        b=bYXil6U8aeDmJjz/7ei+17pn/IQ0sTBX/L0Iva4D7Wz2ESeOPo16kNbkeURvgac0vz
         1B8SPnvLfWhx5F3XaBp3Cqtnpf045rDXKVnpuLAgbbFoSAcAPY5aSoi3yyymWOpv8lPc
         /oWCxfYguys94UmN3T/LwbbkoJ48yDteFsnilb/Df7i1+sZId0JXaZ42gKeFzrWEaZGb
         yK5dHUTa44n4ipKf1p1HeasNuDEY8bBWCvcy64LraZWjsGhNnFRg3oNfNuhfL91Yb2nX
         9MjdGxKDA01dz56VDYMVOqtTHYRqgTaKrdCh6qrYWaFn6YGen4R/32+OfOpr/DEDHIuJ
         lNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XKYDend4fR4Ns4FQUvGIkyd1mejjx00DHoiaI53DpUk=;
        b=lwPutcEWfQcWMJEeVzL3yN9MZU9gt3TAayVIizWQbfcRkxzN2A7CP2BHLgCc0NH+X6
         I8PQ1u12l54j8o8kL54iKYFMEbZ6wEcqAiqjkH7gpX1JKrKUVwNx1D5+BFGqbepv2u4i
         FHKjyMxGpPK/LUNap/smlDrh3FDWCctMRhucBqxfNl5l/36t70w5wcg5IZ5l6TWqg31i
         hTUT4+8QnMnGXjTG6arqn1A2lRUResGOHcEEqTl59+VZDOeofMWAp4eBnLrTX1ZkqnGU
         fhsdGEMksRdbwV+tXdYFFWtW2Ozf1Ih+bK9c2vW/hRlAfar9hDjOsEXitHQOMwFb60Rd
         RhNA==
X-Gm-Message-State: AOAM533iP5JUnb+E7HhCihvdV3IQtZwW1Cctx6I6lqLgjxUlcmo7oV7B
        19BQnCBwIRjxNRHRWU8oZCrtgoyUpq7W0O3jdQY=
X-Google-Smtp-Source: ABdhPJx9rxRjCRa3GYQ4p7AriZSX+wuIRNLIPwg1hDSn19j0bPcIznRbTBs+e+SDM30duj0ltKecu0Y3Yl2H7mgeYW8=
X-Received: by 2002:a2e:990b:: with SMTP id v11mr10986592lji.53.1619399269267;
 Sun, 25 Apr 2021 18:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210423175701.76637-1-marex@denx.de>
In-Reply-To: <20210423175701.76637-1-marex@denx.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sun, 25 Apr 2021 22:07:38 -0300
Message-ID: <CAOMZO5C00Lz1U6vWYCgi2cWG9cCjxSNxrB2Zxn3d5rTTKJQO=Q@mail.gmail.com>
Subject: Re: [PATCH V2] ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators
To:     Marek Vasut <marex@denx.de>
Cc:     "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Ludwig Zenz <lzenz@dh-electronics.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marek,

On Fri, Apr 23, 2021 at 2:57 PM Marek Vasut <marex@denx.de> wrote:
>
> Per schematic, both PU and SOC regulator are supplied from LTC3676 SW1
> via VDDSOC_IN rail, add the PU input. Both VDD1P1, VDD2P5 are supplied
> from LTC3676 SW2 via VDDHIGH_IN rail, add both inputs.
>
> While no instability or problems are currently observed, the regulators
> should be fully described in DT and that description should fully match
> the hardware, else this might lead to unforseen issues later. Fix this.
>
> Fixes: 52c7a088badd ("ARM: dts: imx6q: Add support for the DHCOM iMX6 SoM and PDK2")
> Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: Ludwig Zenz <lzenz@dh-electronics.com>
> Cc: NXP Linux Team <linux-imx@nxp.com>
> Cc: Shawn Guo <shawnguo@kernel.org>
> Cc: stable@vger.kernel.org

You missed your Signed-off-by tag.

With that added:

Reviewed-by: Fabio Estevam <festevam@gmail.com>
