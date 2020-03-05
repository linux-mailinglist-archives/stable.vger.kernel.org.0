Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66DF017A5AE
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 13:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgCEMu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 07:50:58 -0500
Received: from mx2.yrkesakademin.fi ([85.134.45.195]:40172 "EHLO
        mx2.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgCEMu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 07:50:58 -0500
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2020 07:50:57 EST
Subject: Re: block, bfq: port of a series of fix commits to 5.4 and 5.5
To:     Paolo Valente <paolo.valente@linaro.org>, <stable@vger.kernel.org>
CC:     Chris Evich <cevich@redhat.com>
References: <543B99A1-B872-4F06-9A0F-EFFB9CAD5E14@linaro.org>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <e1c874e8-3cc8-7827-447f-b197e7192755@mageia.org>
Date:   Thu, 5 Mar 2020 14:35:49 +0200
MIME-Version: 1.0
In-Reply-To: <543B99A1-B872-4F06-9A0F-EFFB9CAD5E14@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 05-03-2020 kl. 08:49, skrev Paolo Valente:
> Hi,
> Fedora requested the following fix commits, currently available in
> 5.6-rc4, to be ported to 5.4 and 5.5 [1]:
> db37a34c563b block, bfq: get a ref to a group when adding it to a service tree
> 4d8340d0d4d9 block, bfq: remove ifdefs from around gets/puts of bfq groups
> 33a16a980468 block, bfq: extend incomplete name of field on_st
> ecedd3d7e199 block, bfq: get extra ref to prevent a queue from being freed during a group move
> 32c59e3a9a5a block, bfq: do not insert oom queue into position tree
> f718b093277d block, bfq: do not plug I/O for bfq_queues with no proc refs
> 
> No change is needed for these commits to apply cleanly in 5.4 and 5.5.
> 

The last one is already in 5.5.6.

--
Thomas
