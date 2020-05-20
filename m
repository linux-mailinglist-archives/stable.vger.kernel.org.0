Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF471DBE06
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 21:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgETTcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 15:32:31 -0400
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:55906 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726748AbgETTcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 15:32:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1jbUS4-0008Ov-AP; Wed, 20 May 2020 20:32:28 +0100
Message-ID: <c0dbc0d6efc535eefbc8812aced29786595864ad.camel@codethink.co.uk>
Subject: Re: [4.14-stable] Security fixes
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
Cc:     stable <stable@vger.kernel.org>
Date:   Wed, 20 May 2020 20:32:27 +0100
In-Reply-To: <5b5c9da70a78bd84900199153a417dba43ba3c32.camel@codethink.co.uk>
References: <5b5c9da70a78bd84900199153a417dba43ba3c32.camel@codethink.co.uk>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-05-12 at 15:26 +0100, Ben Hutchings wrote:
> Here are some fixes that required backporting for 4.14.  All of them
> are already present in later stable branches.

There's one fix I thought I had included in this, but didn't:

commit af133ade9a40794a37104ecbcc2827c0ea373a3c
Author: Shijie Luo <luoshijie1@huawei.com>
Date:   Mon Feb 10 20:17:52 2020 -0500

    ext4: add cond_resched() to ext4_protect_reserved_inode

This should apply cleanly.  It has already been applied to all other
stable branches.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

