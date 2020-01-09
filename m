Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDDE135658
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 10:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbgAIJ5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 04:57:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:38120 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729944AbgAIJ5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jan 2020 04:57:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3C885C27A;
        Thu,  9 Jan 2020 09:57:49 +0000 (UTC)
Date:   Thu, 9 Jan 2020 09:37:52 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Subject: Re: [LTP] =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for
 kernel 5.4.9-rc1-3abd3b2.cki (stable)
Message-ID: <20200109083752.GA17247@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <cki.7B6FDEE6C3.9EE0H2AAP8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cki.7B6FDEE6C3.9EE0H2AAP8@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> One or more kernel tests failed:

>     ppc64le:
>      ❌ LTP
It'd be nice if there were info which LTP tests failed (or even direct link to
files which has the failure).
There are 20 files related to LTP for ppc64le.

Nothing in dmesg, grep for usual LTP errors didn't find anything
grep -r -e FAIL -e TFAIL -e TBROK -e BROK |grep -v 'FAILED COMMAND File:'

Or am I blind?

Kind regards,
Petr
