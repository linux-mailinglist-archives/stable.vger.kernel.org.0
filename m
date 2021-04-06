Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF66355C7E
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 21:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbhDFTo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 15:44:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhDFTo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 15:44:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95E5361284;
        Tue,  6 Apr 2021 19:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617738258;
        bh=WwLq/QVrVjQNF1a3ZAvV1+zpKjVAXeWGI8o0D6g2hzg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RZKzqmoAtHJ0ybTC2thqDu2YUJ9XGD51zPHb/3P/PVf0U0KKXrOZ/rxf8uOefGo8E
         ZD+LpMRkO3aC98mcEW7Dp2OCyUSHGgSirAr4l7JU0mXVKTufByii6/vsspNcpOuTAu
         FxzTFrf6ijhGKuUIgfJLPGJyY3l+oXN7Fv58gPCTZOzQSEqMVD9xKxrtkuIg7EoTGB
         y9wDJznrrkCpAEkNFenYIZSjqoLLMka9wLANVGCOGzyKsB7/5yHhYnPngpwimSvxmK
         n32inJzui1jxCpC+4YipQ4dfTfImVgW1f8a8FkiWEmBodGsX1ka5VBnceK/BRyQmLp
         dEdjDtCD1s3iQ==
Date:   Tue, 6 Apr 2021 15:44:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 5.10 096/126] KVM: x86/mmu: Use atomic ops to set SPTEs
 in TDP MMU map
Message-ID: <YGy6EVb+JeNu7EOs@sashalap>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085034.229578703@linuxfoundation.org>
 <98478382-23f8-57af-dc17-23c7d9899b9a@redhat.com>
 <YGxm+WISdIqfwqXD@sashalap>
 <fd2030f3-55ba-6088-733b-ac6a551e2170@redhat.com>
 <YGyiDC2iP4CmWgUJ@sashalap>
 <81059969-e146-6ed3-01b6-341cbcf1b3ae@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <81059969-e146-6ed3-01b6-341cbcf1b3ae@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 08:28:27PM +0200, Paolo Bonzini wrote:
>If a patch doesn't (more or less trivially) apply, the maintainer 
>should take action.  Distro maintainers can also jump in and post the 
>backport to subsystem mailing lists.  If the stable kernel loses a 
>patch because a maintainer doesn't have the time to do a backport, 
>it's not the end of the world.

This quickly went from a "world class" to "fuck it".

It's understandable that maintainers don't have all the time in the
world for this, but are you really asking not to backport fixes to
stable trees because you don't have the time for it and don't want
anyone else to do it instead?

Maybe consider designating someone who knows the subsystem well and does
have time for this?

-- 
Thanks,
Sasha
