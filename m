Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6C330EC47
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 07:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhBDGBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 01:01:12 -0500
Received: from mail-03.mail-europe.com ([91.134.188.129]:40562 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhBDGBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 01:01:10 -0500
Date:   Thu, 04 Feb 2021 05:59:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1612418385;
        bh=WF2RIgxe0394g8O3jsxFUWtjjIf2wJAAc2wfSA+IdYQ=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=D2o7z8c/kW77k4+dKCF3RRUBoZv9eLJmEmVU6eVL16vHt8x88SWQeIPyX1FjiPaE5
         Mh15YcPAFkuokb6AwIwp4ytCBUVAX4IGfF2nJrZ6tHjSjtEV7EkIJxX2cHKsnfrmiK
         ryYfjBbz4Y6Ro+s+NUrQJRYpNNNhAaa8IPPKC2as=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Reply-To: Jari Ruusu <jariruusu@protonmail.com>
Subject: Kernel version numbers after 4.9.255 and 4.4.255
Message-ID: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,
I hope that your linux kernel release scripts are
implemented in a way that understands that PATCHLEVEL=3D and
SUBLEVEL=3D numbers in top-level linux Makefile are encoded
as 8-bit numbers for LINUX_VERSION_CODE and
KERNEL_VERSION() macros, and must stay in range 0...255.
These 8-bit limits are hardcoded in both kernel source and
userspace ABI.

After 4.9.255 and 4.4.255, your scripts should be
incrementing a number in EXTRAVERSION=3D in top-level
linux Makefile.

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

