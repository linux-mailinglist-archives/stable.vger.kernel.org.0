Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D3D327F17
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbhCANMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:12:07 -0500
Received: from foss.arm.com ([217.140.110.172]:57668 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235505AbhCANK4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 08:10:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65ABD1FB;
        Mon,  1 Mar 2021 05:10:11 -0800 (PST)
Received: from bogus (unknown [10.163.64.128])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3AA43F70D;
        Mon,  1 Mar 2021 05:10:08 -0800 (PST)
Date:   Mon, 1 Mar 2021 13:10:00 +0000
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     T.E.Baldwin99@members.leeds.ac.uk
Cc:     gregkh@linuxfoundation.org, catalin.marinas@arm.com,
        keescook@chromium.org, oleg@redhat.com, stable@vger.kernel.org,
        will@kernel.org, Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: FAILED: patch "[PATCH] arm64: ptrace: Fix seccomp of traced
 syscall -1 (NO_SYSCALL)" failed to apply to 5.4-stable tree
Message-ID: <20210301131000.avqjoi4vousakiq2@bogus>
References: <1614594817254209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614594817254209@kroah.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Timothy,

On Mon, Mar 01, 2021 at 11:33:37AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>

Looks like simple context mismatch here, the change itself applies
easily. Would you be able to send the backport for v5.4 separately ?

-- 
Regards,
Sudeep
