Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB17E3EB2B5
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 10:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239235AbhHMIh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 04:37:58 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:59737 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239196AbhHMIh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 04:37:57 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id B2133320091F;
        Fri, 13 Aug 2021 04:37:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 13 Aug 2021 04:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=JMaEU/ORw/600wLh1FpgOn1R9xx
        gHjAbfX8/Za0rJJQ=; b=C4OkcyAhymcy2iTF39wRmSKCdN75ZXZ+ywSCEZRRwdI
        51f7gL9lB7CjRMG55COWVwm+xbdtDxMDggpGMnQZl8CBox4o59iW5XtUHjE6ZrZt
        MpzKB3Qi7C/qjIm+vWZiU8nrHTIBUrTTLl/KHkcMXk3fvoHaFcmPwc1jGcPf8mAM
        6rGOAjaq6otoIWa62Yi8fItLRdB7MfX0yaG53kkPku1q9w5dbB8HWlczRzbO1biT
        iIECS2sYlbFF8CeWkKQT7IS2svro6y6pG1JKQMqCeSVvqpiPLxY5qCTC4fBY46Rm
        jseM+b9nTv82jTOinBQI7P6XgS8TqA4gzSdzE5oQUEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JMaEU/
        ORw/600wLh1FpgOn1R9xxgHjAbfX8/Za0rJJQ=; b=mOkE9NPjUS5glxpdCPWqYH
        uJNx1kAokn2b0MnHamJEhkpgh3Wo7OKhw3aAXR3VhTj/msUNjqo2WuxA53JGIzG+
        EzpkpIZhehCBNrv/DxFSE91qu8j3GFxNw53kWP7JmSo0LaLjMlrtpWBRgccIZlow
        nxonJwb9DSOuzu1x+7nulHRaPqysm3DyTeGsr18UU3yMlrpP7fMew1EPTgSy05to
        wLQfLEPsYqoC2Ct5CueRWQ5kF95w/tr+l/uJAl/q0LRoPnfe3DCb+QbuHunEhnRt
        ERaImRUcX6AFJdnZpuRq1nU6ynCWxdwMu4p4Amj8ODGYVp7rfy4mYtJzBiXmnIvA
        ==
X-ME-Sender: <xms:SS8WYUIIWzcmhLAmE_8UATad-2xkGlZpulhBw36IRX1BogS_5lp3vw>
    <xme:SS8WYULs-3sfCwGuxLcTjngJ5NmY7L3vniUrmgp8yj80vSNsSXv02LFFuDub4Z57x
    d1EBtyspWvvtw>
X-ME-Received: <xmr:SS8WYUs8vyDRtZ0ZBVepTISXAaifYR_zBGhN8NjbT3TT4Ai8KsGWVUupQB-gGsOaUIp8ywFpnlQ2SClH9J_UxAigNRA96zyS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeehgddthecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:SS8WYRZ6n6WB_1fT9FApBIypDqnZx0BNiz2koEMQBOy7wxjZM9fuIQ>
    <xmx:SS8WYbaDIqkst2KhzaoXGHX-leMnvQPKu_qKd_V8KhPboi6kqfoZQA>
    <xmx:SS8WYdA0tsa4uqlubA6YGFafC-L8A6o3si6CPsBDQjywJxSXM8-z_w>
    <xmx:Si8WYaXpARazNQ3yZ5jLeOLwdy6nTWSJhZmEKyqhu9aap3sj3NYiPg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 04:37:29 -0400 (EDT)
Date:   Fri, 13 Aug 2021 10:37:27 +0200
From:   Greg KH <greg@kroah.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     stable@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH 4.19.y] tracing: Reject string operand in the histogram
 expression
Message-ID: <YRYvR9VVL3W64KVW@kroah.com>
References: <162850048982205@kroah.com>
 <162866758593.360697.15659863374890557625.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162866758593.360697.15659863374890557625.stgit@devnote2>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 11, 2021 at 04:39:46PM +0900, Masami Hiramatsu wrote:
> commit a9d10ca4986571bffc19778742d508cc8dd13e02 upstream
> 
> Since the string type can not be the target of the addition / subtraction
> operation, it must be rejected. Without this fix, the string type silently
> converted to digits.
> 
> Link: https://lkml.kernel.org/r/162742654278.290973.1523000673366456634.stgit@devnote2
> 
> Cc: stable@vger.kernel.org
> Fixes: 100719dcef447 ("tracing: Add simple expression support to hist triggers")
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  - Since there is no hist_err() APIs in 4.19, this just check the flag
>    and return an error without any error messages.
> ---
>  kernel/trace/trace_events_hist.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)

Both backports applied, thanks.

greg k-h
