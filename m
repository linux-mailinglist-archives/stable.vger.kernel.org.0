Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E181DACDB
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 10:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgETIFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 04:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETIFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 04:05:03 -0400
Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [IPv6:2001:470:1f0b:3b7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A153C061A0E;
        Wed, 20 May 2020 01:05:03 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id A33C5543; Wed, 20 May 2020 10:04:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=valentin-vidic.from.hr; s=2020; t=1589961899;
        bh=yK7wU61+XNDe5ayjqFhyHcHXhrCQnIi9K6wH9jeqssQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w9BbRZzkcc9XXiPyJc7nC2fU8tC2FgYU4zVejiyAznWpkLqxVtUxm1AnJ6JJmuHnG
         7mwexG3YwkNOyxEd7cMM+mWJwLzjhKTPCUr1dLyz1w92GB7PD4sRAJnTMjGKDXg7gB
         ip0m+t4exQsSCms350+8uJHrfvxt2tsInOR/6DMuJhTcccJ07Nwu6qEwFH7lt3quYI
         CsCqxtIcFv6rOoy+kt4DlQcnNxn9QBkhIqjUbiRGJO8IdoKwnypV/QP3RFY+3vAJ4Z
         CAmIiXzbk1tNW69umhm52LGFWFUifMRMvcFq22q/Iflm77jJcbX8mUw5HQWwnVIvX+
         oz3qqlZtnlgtXOxIjjQv63HbVa2cRCfZxUQJF+htjbz2uOoVjO3uAcAglIxmGOm5Ce
         PAm1D4d2Uz4Wi3qgBUXZbq10XtPrJGqJ4CAmYuv6B3QBkjp5fQK/ZyzyuNAmZI2KR9
         491FBUaqBhnEJFGiprPBYvTVZpZIv1AqppB1HIWQBLdsy4JiVrZ8HnyBaYyQKm3Rmf
         8syXXYkLDSzeeTWfO6/RpwARIhpMHfBvCUJMLqhEBJw43pZfOIn0PV119T81FQLzLO
         Mx1w4BFffTcHyNG71ljUa/xhzgqlSZsH/pDIEmtyPJUgV8As3iYp36TxtsnYelu4VF
         s6+Qkml6jpu8Ut5p4pk0BGn4=
Date:   Wed, 20 May 2020 10:04:59 +0200
From:   Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] s390/sclp_vt220: Fix console name to match device
Message-ID: <20200520080459.GP4974@valentin-vidic.from.hr>
References: <20200519181654.16765-1-vvidic@valentin-vidic.from.hr>
 <65218cdb-d03f-29a8-1e78-42ff2d4f958d@de.ibm.com>
 <20200520070743.GO4974@valentin-vidic.from.hr>
 <cba24059-b3a5-1587-c1f3-8d7dfd0807f5@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cba24059-b3a5-1587-c1f3-8d7dfd0807f5@de.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 09:14:23AM +0200, Christian Borntraeger wrote:
> My point was more that a similar issue should happen when installing in LPAR. LPAR
> uses the line mode style console which is ttyS0 for the console but sclp_line0 for the
> tty. How does the debian installer handle this?

I suppose it would fail the same way, but I have no way to verify.

> Regarding your patch I fear that this patch would break existing
> setups so we cannot use it as is.

Right, if some software/documentation depends on the name ttysclp0,
then I guess it is not possible to change any of the two names.

-- 
Valentin
