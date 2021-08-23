Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F513F4C13
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 16:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhHWOJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 10:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhHWOJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 10:09:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DFCB61206;
        Mon, 23 Aug 2021 14:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629727727;
        bh=tlLFxJY+JYRvy77IGvTDOiXa4odg7ZRQd6rAUpOdcPw=;
        h=Date:From:To:Subject:From;
        b=nqgVsf0I7/Aa0DPOoLOtsCxNcDtjnBwO7u3ZiMqPEiKbhElGhRFdA4u3CTdoEZkn8
         amOgHM8phylQUhER0HwwICPzg9LhRjBvrm6TRZWavOlM5tEzAI3AdWstenuCqpmOWC
         ab2VT/M9GBlZYWtordO2tNmYXMOTeYcquSlZZZGQtaeISsBg73WWvYeA94AQI49nmT
         272wpZMVEzShyJfxOCgYZKGBN4G5JbP1eAGnbkypuPk+4k/SEvWFwnD8MoBks2m3Ax
         E4gZ30jckxayFVUYJr53P00nQDRE10/mcrHTkZbILMujQtNtzU/muAjjqo6Bu++E+N
         T4LKOj44xgyhA==
Received: by pali.im (Postfix)
        id DE340FC2; Mon, 23 Aug 2021 16:08:44 +0200 (CEST)
Date:   Mon, 23 Aug 2021 16:08:44 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Drivers for Qualcomm wifi chips (ath*k) and security issues
Message-ID: <20210823140844.q3kx6ruedho7jen5@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sasha and Greg!

Last week I sent request for backporting ath9k wifi fixes for security
issue CVE-2020-3702 into stable LTS kernels because Qualcomm/maintainers
did not it for more months... details are in email:
https://lore.kernel.org/stable/20210818084859.vcs4vs3yd6zetmyt@pali/t/#u

And now I got reports that in stable LTS kernels (4.14, 4.19) are
missing also other fixes for other Qualcomm wifi security issues,
covered by FragAttacks codename: CVE-2020-26145 CVE-2020-26139
CVE-2020-26141

People have already asked if somebody is already doing backports to 4.19
of patches for these security issues, but there was no response, see email:
https://lore.kernel.org/linux-wireless/704e1c77-6c48-79f7-043a-b2d03fbfef8b@candelatech.com/

I got information that issues for ath10k are again going to be (or are
already?) fixed in some vendor custom/fork kernels, but not in official
stable tree 4.14/4.19 (yet).

This situation is really bad because lot of times I hear to use mainline
kernel versions or official stable LTS tree (which are maintained by
you), but due to such security issues in LTS trees which stays unfixed
and others say to use rather vendor custom/fork kernels where it is
claimed that issues are fixed.

And because there is no statement for end users (end users do not
communicate with vendors and so they do not have information what is
supported and what not), end users just use what Linux open source
distributions have in their kernels (which lot of times match official
LTS kernel trees). And users think that everything is OK and security
issues are fixed.

So there is really a need for public statement from you or Qualcomm
side, if stable LTS kernel trees are going to include security fixes for
drivers used by Qualcomm wifi chips (ath*k) or not or under which
conditions. And what should users / Linux distributions use if they do
not want to have years-old unpatched drivers with security issues. Such
information is really important also for distributions which include
unmodified (or slightly modified) kernel LTS trees into their own
packages. As they also need to know from which source should take
(e.g. Qualcomm wifi) drivers for their systems to ensure that have
security patches applied.

I can understand that you or other people or volunteers do not have time
to track or maintain some parts of drivers. So nothing wrong if official
statement is that stable trees X and Y do not receive security updates
for driver A and B anymore. Also I can understand that it takes some
time to include required fixes, so expect fixes for A and B in X and Y
versions with one month delay. But it is needed to know what should
people expect from LTS trees for particular drivers. Because I think it
is not currently clear...

Do not take me wrong, I just wanted to show that this is hidden problem
which needs some discussion.
