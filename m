Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80AD224503
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 22:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgGQUPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 16:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbgGQUPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jul 2020 16:15:42 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5E4E2074B;
        Fri, 17 Jul 2020 20:15:40 +0000 (UTC)
Date:   Fri, 17 Jul 2020 16:15:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Gregory Herrero <gregory.herrero@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] recordmcount: only record relocation of type
 R_AARCH64_CALL26 on arm64.
Message-ID: <20200717161538.39edfa46@oasis.local.home>
In-Reply-To: <20200717200119.GP17377@ltoracle>
References: <20200717143338.19302-1-gregory.herrero@oracle.com>
        <20200717133003.025f2096@oasis.local.home>
        <20200717200119.GP17377@ltoracle>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 17 Jul 2020 22:01:19 +0200
Gregory Herrero <gregory.herrero@oracle.com> wrote:

> Thanks Steve.
> Should I send a V2 to add 'Cc: stable@vger.kernel.org' in the commit
> description or can someone take care of it when adding the commit to
> the tree?

If I was taking it, I would simply add the Cc: stable@vger.kernel.org
to the commit log, and no resend would be needed.

It's up to the ARM64 maintainers to decide in this case.

Cheers,

-- Steve
