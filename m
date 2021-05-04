Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9BA372C30
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 16:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhEDOjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 10:39:01 -0400
Received: from mail-0201.mail-europe.com ([51.77.79.158]:34822 "EHLO
        mail-02.mail-europe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231127AbhEDOjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 10:39:01 -0400
Date:   Tue, 04 May 2021 14:22:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1620138172;
        bh=j/Piey25x5wTKkcS2omjRTtsTy4ygKZu9xmZybpv4I0=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=qtZubhb+ReF4/oBIQKURLtV8i7jbCDw4U3xOsdmHuU1b0MQYwCw2gR3CfGJrNYgrK
         o5i4SNr49XZzlYtBfc8cwIn8XZeAD9LRobrnEn82qTU7V/Chw0mHvf5ito8UYtwNfr
         6SFZ8QwZnNWyxpxRSimkqfFS+rpM57mXEhm+zA2U=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Reply-To: Jari Ruusu <jariruusu@protonmail.com>
Subject: Re: [PATCH 5.10 1/2] iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <g5YP678olZEf3yQNX2ptK3X6DceFoemqwzEgSJclx_dHFAJfbJBWznYtB74u5g69Onx_6QZkLF-K2muYLa3qsotkPpxbHYuz4Hrs94olZ7c=@protonmail.com>
In-Reply-To: <YJFNyOGrF8RcTTlc@kroah.com>
References: <20210430141910.473289618@linuxfoundation.org> <20210430141910.521897363@linuxfoundation.org> <608CFF6A.4BC054A3@users.sourceforge.net> <YI6HFNNvzuHnv5VU@kroah.com> <bO2GF-6sC-I4NbFif7JoGUpuRpAV-rHEMwtLsKfN9SCsA0lwB1NgEV4OC7Xd5fdoq3UPcZ6-uh2VDSe1Xtovy8ti3k5vmOsiMVTdfTgl0Yw=@protonmail.com> <YJD2uTdQonXymbn6@kroah.com> <npSsinT79DB6Ze8QTkmLcuOTyVwRcy2FbOf0tDjpEHbTxKdYmLar8Br66_ypLjzZ86sIJKnSbUHeehagPR6RqxsJsKdWW_vWnXOUEhMC14g=@protonmail.com> <YJFNyOGrF8RcTTlc@kroah.com>
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

On Tuesday, May 4, 2021 4:36 PM, Greg Kroah-Hartman <gregkh@linuxfoundation=
.org> wrote:
> On Tue, May 04, 2021 at 01:05:56PM +0000, Jari Ruusu wrote:
> > second patch is upstream commit e7020bb068d8be50a92f48e36b236a1a1ef9282=
e.
>
> This is not in any newer stable trees, and it was not obvious what you
> were doing here at all.

That patch is in 5.10 + 5.11 + 5.12

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dlinux-5.10.y&id=3D2a442f11407ec9c9bc9b84d7155484f2b60d01f9

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dlinux-5.11.y&id=3Da9315228c1d4b1ced803761e81ef761d97f3e2fa

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dlinux-5.12.y&id=3Df935c64a0c87d86730efd6e1e168555460234d04

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

