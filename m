Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D702E4884BA
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 17:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiAHQw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 11:52:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54070 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiAHQw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 11:52:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E0CE60DE6
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 16:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A36C36AE0;
        Sat,  8 Jan 2022 16:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641660776;
        bh=GoFbup5Zu0mQI6rdRLM6a21oPTndNOdawQy93Zu29D8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S/zW+qf2EKxN8mWrUzv+d0IyaU56Um+LpOGPSCpShDY+wyAmXEWKjCoIfvsGE625O
         cfsiLVqsvKJof5yKv2V8eDOj9Uv+KQWOw4nqqsTNTrhBsHQDTf3yrf1wszYP2ghmr4
         ZJQ2hLj1I/3GmC4EiqmaA8qdE4HWX/kEqVA/TJ/0=
Date:   Sat, 8 Jan 2022 17:52:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ercan Ersoy <ercanersoy@ercanersoy.net>
Cc:     security@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix uninitialiazed variable bug
Message-ID: <YdnBZXiGf57u6fut@kroah.com>
References: <d796d15c3577a35a46e4feac7e6a9e85@ercanersoy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d796d15c3577a35a46e4feac7e6a9e85@ercanersoy.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 08, 2022 at 07:37:59PM +0300, Ercan Ersoy wrote:
> 
> This bug is in mem_cgroup_resize_max function
> in mm/memcontrol.c source file.
> 
> Signed-off-by: Ercan Ersoy <ercanersoy@ercanersoy.net>


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
