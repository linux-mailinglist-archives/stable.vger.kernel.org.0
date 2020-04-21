Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CA11B2E31
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgDURUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:20:50 -0400
Received: from mx1.yrkesakademin.fi ([85.134.45.194]:49369 "EHLO
        mx1.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgDURUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:20:49 -0400
Subject: Re: block, bfq: port of fix commits to (at least) 5.6
To:     Paolo Valente <paolo.valente@linaro.org>,
        stable <stable@vger.kernel.org>
CC:     Chris Evich <cevich@redhat.com>,
        Patrick Dung <patdung100@gmail.com>,
        <jordanrussellx+kobz@gmail.com>,
        Thorsten Schubert <tschubert@bafh.org>
References: <BD02F95A-0A08-4BEB-9309-9941998EE14C@linaro.org>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <d1583eef-44a0-a278-09c0-45dbfb2e4403@mageia.org>
Date:   Tue, 21 Apr 2020 20:20:46 +0300
MIME-Version: 1.0
In-Reply-To: <BD02F95A-0A08-4BEB-9309-9941998EE14C@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 21-04-2020 kl. 13:25, skrev Paolo Valente:
> Hi,
> a bug reported for Fedora [1] goes away with the following fix
> commits, currently available from 5.7-rc1.
> 
> 4d38a87fbb77 block, bfq: invoke flush_idle_tree after reparent_active_queues in pd_offline
> 576682fa52cb block, bfq: make reparent_leaf_entity actually work only on leaf entities
> c89977366500 block, bfq: turn put_queue into release_process_ref in __bfq_bic_change_cgroup
> 

Just to point out to others picking theese patches...

the list should be applied in reverse order from bottom up (meaning 
c89977366500 first, then 576682fa52cb and 4d38a87fbb77 last...)


> It would be useful for Fedora to have these fixes in (at least) 5.6.
> No change should be needed for these commits to apply cleanly.
> 
> Thanks,
> Paolo
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=205447#c84
> 

--
Thomas



