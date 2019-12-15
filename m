Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2413311FAAD
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 20:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfLOTJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 14:09:39 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.25]:21583 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfLOTJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 14:09:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1576436977;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=NuwJqjKb01zSnfjHob0wGTDJJYSovgaaXZgXso59XUY=;
        b=F5wM5aj1v/SbwKuCe059pPnntoBV5AP9mGCwvNV5faRsfjV4bIESZZy92G6Flw6PeQ
        H0I4eMeup9yZhLhrpv3kMQfqh1A12qa7MituAyQVCZGxqPTFwKAtQU+U0hCtGok+BAE2
        oR3aa1vWRw/X1rpiAmox9pCN1HWhd3zfW6eoe5Bg47UsuXR6/fDY+5TKQEc0g+fWKiIb
        6fj5i+Hw4W06vn/QMxgCeFzsXWcjDJ5qbE7f4uXPJmTyX57F5gNYhAT+Dy49PyLref8Z
        3Ny4wbl0SBKWAxcheQCb8GQK9GTyK51AlUhA4+zOQMysR2Nya730VeB/noPkqj+kJLT7
        BvQA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGH/PgwDGiVw=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.0.7 DYNA|AUTH)
        with ESMTPSA id i03ca8vBFJ9YEDb
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Sun, 15 Dec 2019 20:09:34 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: FAILED: patch "[PATCH] omap: pdata-quirks: remove openpandora quirks for mmc3 and" failed to apply to 4.14-stable tree
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20191215174935.GA856758@kroah.com>
Date:   Sun, 15 Dec 2019 20:09:34 +0100
Cc:     stable@vger.kernel.org, tony@atomide.com, ulf.hansson@linaro.org
Content-Transfer-Encoding: 7bit
Message-Id: <20E4BE11-9846-4A94-9437-5C722D1E2B8E@goldelico.com>
References: <157641677913676@kroah.com> <B77B52F8-BD0E-41D1-ACEF-6440E9C59CED@goldelico.com> <20191215174935.GA856758@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3124)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Am 15.12.2019 um 18:49 schrieb Greg KH <gregkh@linuxfoundation.org>:
> 
> On Sun, Dec 15, 2019 at 06:37:34PM +0100, H. Nikolaus Schaller wrote:
>> Please apply this before: https://patchwork.kernel.org/patch/11232473/
> 
> Links are fun :(

Sorry.

> 
> What is the git commit id of the patch in Linus's tree to apply first?
> That I can work with.

4e8fad98171b omap: pdata-quirks: revert pandora specific gpiod additions

BR and thanks,
Nikolaus Schaller
