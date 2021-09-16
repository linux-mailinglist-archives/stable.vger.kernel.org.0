Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BAC40DBB4
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbhIPNvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235923AbhIPNvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 09:51:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93BC060F21;
        Thu, 16 Sep 2021 13:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631800215;
        bh=Bo3EdCRmWBeiblM21OGKWCMLYKq0RT6jaQWeQw88eMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b5pq23e/V4U96v8ippoW1HvJ+QSDIr/Xac9ukcu+cNLHvEw3SiyZm+Vfpbf7kkuu/
         G7ymBLciVP8WUwlMODQTmZb9oMvNlCpsPPw5rah1khsL0tewkw+8855LTyi8r7r84O
         Tr9O15VrlmT09fL0MGwGdJAanx2qwaKsM9AUwgrg=
Date:   Thu, 16 Sep 2021 15:48:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michel =?iso-8859-1?Q?D=E4nzer?= <mdaenzer@redhat.com>
Cc:     alexander.deucher@amd.com, christian.koenig@amd.com,
        evan.quan@amd.com, lijo.lazar@amd.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work when
 GFXOFF is disabled" failed to apply to 5.14-stable tree
Message-ID: <YUNLMkxQPw/empni@kroah.com>
References: <163179752354221@kroah.com>
 <7fe8e175-efdc-b7d9-ab86-44aeec60c2e9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7fe8e175-efdc-b7d9-ab86-44aeec60c2e9@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 03:39:16PM +0200, Michel Dänzer wrote:
> On 2021-09-16 15:05, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> It's already in 5.14, commit 32bc8f8373d2d6a681c96e4b25dca60d4d1c6016.

Odd, how were we supposed to know that?

> Please do backport it to older stable trees.

The above commit is already in 5.10.62 and 5.13.14.

thanks,

greg k-h
