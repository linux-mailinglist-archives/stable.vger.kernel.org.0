Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9151E3102
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 23:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390760AbgEZVQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 17:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390435AbgEZVQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 17:16:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF77320888;
        Tue, 26 May 2020 21:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590527763;
        bh=kLV44yBWHPoT0T+3cEG/J3rOYNiGRyHwi2HVP15oYao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=klTqCpIwX3VLtGCp+OKNHF5EJGtoR7u+BnCQZyqhMKg1pD2WdGe7Arsy0LNRzPTR8
         2t+aVgefOfClQUZlWeh1dbWJHDiW7Lv8SRraHL9UeCMZdFHGA7dVNVllMpCBRlktuo
         Pj8Kv7kflWg2arOlWVVYfLSSUHbVGaReUkfUYsLo=
Date:   Tue, 26 May 2020 23:16:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        Andi Kleen <ak@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <20200526211601.GA166522@kroah.com>
References: <20200526052848.605423-1-andi@firstfloor.org>
 <20200526065618.GC2580410@kroah.com>
 <202005260912.8867B3AA@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202005260912.8867B3AA@keescook>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 09:15:04AM -0700, Kees Cook wrote:
> On Tue, May 26, 2020 at 08:56:18AM +0200, Greg KH wrote:
> > What about those systems that panic-on-warn?
> 
> This is (modulo the general discussion about whether it's the right
> way to check) the correct use for WARN*(). It's an undesirable system
> state; people choosing panic-on-warn want this:
> https://www.kernel.org/doc/html/latest/process/deprecated.html#bug-and-bug-on

Ok, tha's good to know, thanks for that.

greg k-h
