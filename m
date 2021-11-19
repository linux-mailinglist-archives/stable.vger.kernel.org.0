Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B44456FB3
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 14:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhKSNgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 08:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhKSNgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 08:36:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FD6C610D2;
        Fri, 19 Nov 2021 13:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637328827;
        bh=NmLIf9ZgO6nxMfgGEwQmMZTr/h53SQ3rccIEV2+izjE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jorJWElcTrTXZAMENTOx955aLDifOeFcw4V2t3RlP7PorC5aY4FoxVL/AJ01PnzMc
         04fxgflESxo+fzMl7pd4mSEi4HPomHIB1ajJyTe9H2IXZCiCB4b++DRX6/fZ93dTkD
         dGttjjISePyHqtcKEzGekLZOXadq+gFDBxhSHsZ8=
Date:   Fri, 19 Nov 2021 14:33:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     paulburton@google.com, joelaf@google.com, mingo@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Resize tgid_map to pid_max, not
 PID_MAX_DEFAULT" failed to apply to 4.14-stable tree
Message-ID: <YZenufJKeIJrA35O@kroah.com>
References: <162635653777192@kroah.com>
 <20211116145223.651cd5bd@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116145223.651cd5bd@gandalf.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 02:52:23PM -0500, Steven Rostedt wrote:
> This was in my queue for some time. But I finally got around to testing it.

Now queued up,t hanks.

greg k-h
