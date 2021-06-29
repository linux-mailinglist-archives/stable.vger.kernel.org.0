Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C826F3B7A2C
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 00:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhF2WEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 18:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232997AbhF2WEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Jun 2021 18:04:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94E1361D70;
        Tue, 29 Jun 2021 22:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625004135;
        bh=WYv2SkyaHwknr7OSym3SYwEgz/DGRDrjM1Sp41gp+c0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QPPkBAWjuwWyA2+cAPAX6rTsz0iTHRCkwrhKMlRzyBEVL9AFJ+WEhIjHg1e13CFV/
         n351VCGMT336ygXB9Z7R9ZlTsTYfp30iwvpchiX3bPb+4OGUVJHhuN1MZd9TpDmmiG
         xp+UX5cGmXF+LAb4pd2+F+fe6r4QCGxlJQ/bByu8LuUGGoN9rnrGW2xG8HnxAH2PSF
         C5ibhDxsv45izr2whNxEOZVfRdLhOgJz8NdczTcahfoXrwfubJ6+8AWOZY1BLPuMv6
         ZE1O35NqifRPKZjC6SIANcY/jGmkrl5VGwLp4Ez6o0j5XWHOSrvffF6mAntk1XaVzr
         dPzhFeX+uHHyA==
Date:   Tue, 29 Jun 2021 18:02:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Anil Altinay <aaltinay@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: CVE-2021-3444
Message-ID: <YNuYZqgFY5VM0hRr@sashalap>
References: <CACCxZWMREz1AVchULrWpdvtXYdDXJPNbC3qJicQ-S6UnfTbCUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACCxZWMREz1AVchULrWpdvtXYdDXJPNbC3qJicQ-S6UnfTbCUQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 29, 2021 at 01:06:00PM -0700, Anil Altinay wrote:
>Hi,
>
>I realized that this cve(
>https://www.openwall.com/lists/oss-security/2021/03/23/2 ) is not in
>the 4.19 tree but the commits introduced the vulnerability before
>4.19. Is there any reason that the fix was not cherry-picked to 4.19?

Backport wasn't trivial, and no one seemed to care enough about 4.19.
Feel free to backport the fix and send it out for review.

-- 
Thanks,
Sasha
