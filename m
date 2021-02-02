Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4309030BCAE
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 12:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhBBLLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 06:11:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhBBLKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 06:10:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35B4D64DBA;
        Tue,  2 Feb 2021 11:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612264183;
        bh=vFq7NeMfV2przweTzpyrmikuLaJJ1nfz6/jdCK3tvEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GX2Qcv4WYw5IZEx26CjLWvUiGDL/karsEKhSceYQZLLruY6Ewbzels1ZEvisjawhZ
         D3qzytq1cwpJMnQYocZ4IcppouH+1Wz/3j4vgxnWqxGrIUtJJy4W/d3gEeFF7iZ3li
         kb1nfedYhgalG/kXAJqES4bf/+V2ZQ8jhpyKFUWQ=
Date:   Tue, 2 Feb 2021 12:09:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        devel@driverdev.osuosl.org, Masahiro Yamada <masahiroy@kernel.org>,
        stable@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH] staging/mt7621-dma: mtk-hsdma.c->hsdma-mt7621.c
Message-ID: <YBky8lfQ1DmuKtRL@kroah.com>
References: <20210130034507.2115280-1-ilya.lipnitskiy@gmail.com>
 <20210202065438.GO2696@kadam>
 <20210202083117.GS2696@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202083117.GS2696@kadam>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 11:31:17AM +0300, Dan Carpenter wrote:
> Apparently this was already merged?  Never mind then.  Once it's merged
> it can't be changed.  No big stress...

Sorry, yes, already in my tree...
