Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C2E2B5E33
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 12:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgKQLXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 06:23:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbgKQLXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 06:23:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93CA6221F8;
        Tue, 17 Nov 2020 11:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605612212;
        bh=nLUeiZEkg5qMWXpeCTFAjFlJRurSbbLQlwCd4b7iFng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cUgkw5dXxOjTfEAmB1JVEz6DrngUp1U+SlroFltk1ULlmuwAj/1RiWdnVm92mR9We
         q4aoRLCYBlEHPYQ8DN3kI0nwOAckP0JbCaz6wQm1VcUVhH35DYBzTgUtsTtJ3Pu7YE
         rs98BN2B0vRqUiomr/ooLTmvYBaTn1bwETDLehzU=
Date:   Tue, 17 Nov 2020 12:24:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Wei Liu <wl@xen.org>
Subject: Re: backport of 073d0552ead5 ("xen/events: avoid removing an event
Message-ID: <X7Oy434ypKHduJis@kroah.com>
References: <20201112173100.6rbaklb74ofkltl5@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112173100.6rbaklb74ofkltl5@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 12, 2020 at 05:31:00PM +0000, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> This was missing from v4.4.y, v4.9.y and v4.14.y. Please consider
> the attached backported patch.
> Missed adding stable in the previous mail.

This needs a much longer series for these trees that has already been
sent to me by Juergen.  I'll go queue those larger series up now, which
includes this fix as well.

thanks,

greg k-h
