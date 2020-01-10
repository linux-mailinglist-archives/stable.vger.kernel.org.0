Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7581368BC
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 09:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgAJIDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 03:03:12 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41836 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgAJIDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 03:03:10 -0500
Received: by mail-lj1-f194.google.com with SMTP id h23so1145128ljc.8
        for <stable@vger.kernel.org>; Fri, 10 Jan 2020 00:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=upQt3GzlnvjSOqoMwk/degessP4GmM83hujHAC7qtm0=;
        b=cxcFzrW2eyB+uI590hq5nOTUQHHVRUT6Thep14+XyUUFBXMNKMnghxjuFE9IkBsnz7
         aqXKN1s4ZBhEZx1ujM7yedQW+6vlI46+a6WCiTQvAzbDCiMS6yZfZVrMnmUYJkc2gfpF
         /CRsUCehyGHLcauGq+mpESjqOADm8pXGiyBaEhuYn1/vo/aaotw5pz51Gw4EtR6IlhZ9
         3/7oXUJnFngHFALfDH1Pa2IJ5yd++kplyC/swZm7UHPAh8/x34gB9Q+ZWhzvrb/W0MTW
         EHMYkMkkWTLX8aijook0wH6sLNcZN94BmYUsDoXklLfgKttL4pL5KNmF9G22Q4cizAgE
         iL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=upQt3GzlnvjSOqoMwk/degessP4GmM83hujHAC7qtm0=;
        b=iytn+JBVsFirxXyQdWs88G4QJsDqPEuwPdr5gAv+o3xSjwDJ9pyi5YBH+q5m5IF54R
         oRHmUB3iSzexp6n49uW/sclrsMFvgZHf2wBwho89gCcKAC5aeUliD3pBkRnya2G4RcLq
         3Bf+A7aH6z8g77DY34LBUxez19Qk0V+0+qPPuC0BjjIKXvKOuN3WYCcmaaHTUqKZUlX0
         cY66eEKU/kYMorWIQeMxZLZayFrKf/57s5cB5iEshVcqNgOJPZQ5tIySPNcKCovWVQl4
         74b1FBFfHcqNfTkmmOKreqdHhqV8xmPBOS8qrzjjLaQWvw4H+O56keM7RCZxLX9UsTQ2
         GnqQ==
X-Gm-Message-State: APjAAAX5vXLtvZDLIj1tR3BZ4W2RNlYhNgRNa/OdUS97lt5FiNZPBeit
        wsv0ujFsMl1yURTHxrLMPZIy33hEL+mE+sIZoNoJkQ==
X-Google-Smtp-Source: APXvYqzgj8OGge7NQJchcfB33MSmUCAalLcd1nHlhSwplwywzQr3fVX9R/RNGsRHqOEFszThgJZ8r0py0uns5CQu5FM=
X-Received: by 2002:a2e:868c:: with SMTP id l12mr1539426lji.194.1578643388598;
 Fri, 10 Jan 2020 00:03:08 -0800 (PST)
MIME-Version: 1.0
References: <20191106173125.14496-1-stephan@gerhold.net> <CACRpkdaH8ahbVKTrBHh7NKVZVg-PZvyKDKNityEyv5rL8=Qdag@mail.gmail.com>
In-Reply-To: <CACRpkdaH8ahbVKTrBHh7NKVZVg-PZvyKDKNityEyv5rL8=Qdag@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 10 Jan 2020 13:32:57 +0530
Message-ID: <CA+G9fYvSQJ0BVAAMyTk0mViqCdNjtsZCrhhorRnrmcPg98yQVA@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: ab8500: Remove AB8505 USB regulator
To:     Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 7 Nov 2019 at 13:32, Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Wed, Nov 6, 2019 at 6:33 PM Stephan Gerhold <stephan@gerhold.net> wrote:
>
> > The USB regulator was removed for AB8500 in
> > commit 41a06aa738ad ("regulator: ab8500: Remove USB regulator").
> > It was then added for AB8505 in
> > commit 547f384f33db ("regulator: ab8500: add support for ab8505").
> >

Stable-rc 4.4 branch arm build failed due to this error.

arch/arm/mach-ux500/board-mop500-regulators.c:957:3: error:
'AB8505_LDO_USB' undeclared here (not in a function); did you mean
'AB9540_LDO_USB'?
  [AB8505_LDO_USB] = {
   ^~~~~~~~~~~~~~
   AB9540_LDO_USB
arch/arm/mach-ux500/board-mop500-regulators.c:957:3: error: array
index in initializer not of integer type
arch/arm/mach-ux500/board-mop500-regulators.c:957:3: note: (near
initialization for 'ab8505_regulators')

Full build log,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.4/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/703/consoleText

--
Linaro LKFT
https://lkft.linaro.org
