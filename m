Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAAD4A727D
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 15:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiBBOBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 09:01:48 -0500
Received: from nef2.ens.fr ([129.199.96.40]:47536 "EHLO nef.ens.fr"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233516AbiBBOBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Feb 2022 09:01:48 -0500
X-ENS-nef-client:   129.199.1.22 ( name = clipper-gw.ens.fr )
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ens.fr; s=default;
        t=1643810505; bh=ID2z+aW/RbVunePrptyZW/E8X5W33QCbyfQ3YpYn2KY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHBaKizX8jttsK+uabCyldttj9BvPqpxqDufqxo451V8O2e+ZkKfkjtxjcOyHuz+j
         +BowO2FmCDLccFTjWlSj5xDitn3xph/EDgAfA5iAapcj9K9mfN/cz80oX5R8/N8QnX
         Mn2eRiDs6P8heh6JJiYZ+GD0sHKN5K/vSArz57jE=
Received: from clipper.ens.fr (clipper-gw.ens.fr [129.199.1.22])
          by nef.ens.fr (8.14.4/1.01.28121999) with ESMTP id 212E1jGF002622
          ; Wed, 2 Feb 2022 15:01:45 +0100
Received: from  optiplex-7.sg.lan using smtps by clipper.ens.fr (8.14.4/jb-1.1)
       id 212E1es6015093 ; Wed, 2 Feb 2022 15:01:45 +0100 (authenticated user gbertholon)
X-ENS-Received:  (maths.r-prg.net.univ-paris7.fr [81.194.27.158])
From:   Guillaume Bertholon <guillaume.bertholon@ens.fr>
To:     gregkh@linuxfoundation.org
Cc:     guillaume.bertholon@ens.fr, stable@vger.kernel.org
Subject: Re: [PATCH stable 4.4] KVM: x86: Fix misplaced backport of "work around leak of uninitialized stack contents"
Date:   Wed,  2 Feb 2022 15:00:28 +0100
Message-Id: <1643810428-6769-1-git-send-email-guillaume.bertholon@ens.fr>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <YflzRMVgi+NB4ETP@kroah.com>
References: <YflzRMVgi+NB4ETP@kroah.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (nef.ens.fr [129.199.96.32]); Wed, 02 Feb 2022 15:01:45 +0100 (CET)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Feb 2022 18:52:04 +0100, Greg KH wrote:
> Note, 4.4.y is about to go end-of-life now, so I wouldn't spend much
> more time on it if you do not want to.

Since I already wrote it, I will send one last patch on the 4.4.y branch,
and then I will move to 4.9.y.

If you think it is a waste of your time, feel free to ignore it.

As a last contribution to 4.4, I can also report that backported
commit b7cf6750c05a ("drm/amdgpu: when suspending, if uvd/vce was running.
need to cancel delay work.") applies a fix for `amdgpu_uvd_suspend` in the
function `amdgpu_uvd_resume`, but I am not sure of where the instruction
should go, so I could not make a patch for this one.

Sorry for the bad timing,
- Guillaume Bertholon
