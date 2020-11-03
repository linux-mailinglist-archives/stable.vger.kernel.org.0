Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B330F2A3E15
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 08:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgKCHyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 02:54:33 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:42293 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCHyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 02:54:32 -0500
Received: from 'smile.earth' ([95.89.3.76]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MWSJJ-1kpe4L1WbD-00Xqcp; Tue, 03 Nov 2020 08:54:22 +0100
X-Virus-Scanned: amavisd at 'smile.earth'
From:   Hans-Peter Jansen <hpj@urpla.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5.9 24/74] x86,
 powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()
Date:   Tue, 03 Nov 2020 08:54:19 +0100
Message-ID: <1872362.uFc3Iqf4nr@xrated>
In-Reply-To: <20201103063529.GB74163@kroah.com>
References: <20201031113500.031279088@linuxfoundation.org>
 <5149714.arhZky3dcl@xrated> <20201103063529.GB74163@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:Pa1iUTWvUx3e2k75U3b9EYy12TKQINJKwbZWWGCi4BlsWBZvRab
 nVZGEuWjwnXqz4RIF+1GqQq75c5oqhEuXB+S+naEFRWXfsf6VYXey0bPdCpJWunLgmem7+7
 mCzcH7PXNauBY/6cC6t4n7u3GVCMEmTPYcspYkJ7pIKA+0OxmkJvkMkHyo1vCQypbuFfZRo
 nvfM6TKHHUITGazed4WHQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tCTrpxcCzBs=:h0ubUBx5WnIGNjjnlrBYdv
 cV9+z23yVQOkSGrxr5gxoyX48NyldDCuACgnrBZ4EuTOdlyL1ZeZOcUYuQwVv/wD9gKoZ2jEz
 DPPTidwWqJuyFfmaM9C0P0EESrjqzaMA8bO46AGioEhYIAVIjbql1cAnKCRhWb+Jgt/3A36DO
 BoAS1zIclsNS6HbQduggT/fBS6b6YrrFjX7MkZiMEJ9wL0eOI5BI3v7yzioFJ7yPl0N0+9SRd
 t3wR2SvvN6Qiik6S+gizeX4TuKPfjofSyNbntcOLdTzOq2irKY91rQrPVVoB/nkSgf41AR8Pc
 sOsCMfftNhoM54YpKJohJP2GTzUfSEQBlCTWMDAzHZqIITgEpLl6LQe8hsZDkxRluR10JhxUs
 u9TITuzNmEOLha3LQPSwEhErFGxgEoW1a0cVW7N3ALpQKvVbBuK3dbjtJ6kRH
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Dienstag, 3. November 2020, 07:35:29 CET schrieb Greg Kroah-Hartman:
> On Mon, Nov 02, 2020 at 10:34:08PM +0100, Hans-Peter Jansen wrote:
> 
> Ah, that kind of makes sense, I saw odd things with these patches that I
> couldn't figure out.
> 
> So, is there a symlink that I need to add/fix to resolve this?

rm tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S should 
do the trick.

Cheers,
Pete





