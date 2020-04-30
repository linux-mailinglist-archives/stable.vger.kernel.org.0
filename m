Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA941C0B01
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 01:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgD3Xd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 19:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgD3Xd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 19:33:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 805A020774;
        Thu, 30 Apr 2020 23:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588289638;
        bh=baJR6UIUm/F60vtaqnZuQ4PRhDzcBMlgEnwoEmlkSe0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bzJ4/U7DZX6ygA0HLcux0xJbX9KVPwk1L+QtaguSmW7yZTw0VpwmPOooOiwZlrHrj
         kjwCL8rs9c5kj3AwVdfDtSXlq751lDxEZl+qJlJnLlkDerCZ/qJEpmZK1z9pCGLTyT
         OtRC2YmmQzxKkMM8emECUbiq4GDwF2MZJoLTHYdQ=
Date:   Thu, 30 Apr 2020 19:33:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     rananta@codeaurora.org
Cc:     stable@vger.kernel.org
Subject: Re: Request to backport a patch onto 5.4.y stable
Message-ID: <20200430233357.GA13035@sasha-vm>
References: <b8f451c80fe1cd57bdd4fea74d21e8cd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b8f451c80fe1cd57bdd4fea74d21e8cd@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 01:36:45PM -0700, rananta@codeaurora.org wrote:
>Hi,
>
>I need help to backport the patch with the following details onto the 
>5.4.y stable branch:
>Subject: [PATCH] tty: hvc: Fix data abort due to race in hvc_open
>commit-id: e2bd1dcbe1aa34ff5570b3427c530e4332ecf0fe
>Reason: The issue addressed in the patch was discovered on 5.4.y branch

Is it in Linus's tree?

-- 
Thanks,
Sasha
