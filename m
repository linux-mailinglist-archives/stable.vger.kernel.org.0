Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666276568DA
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 10:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiL0J1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 04:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiL0J1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 04:27:46 -0500
Received: from out20-39.mail.aliyun.com (out20-39.mail.aliyun.com [115.124.20.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F5D9594
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 01:27:44 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.05915186|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.0115035-0.00256055-0.985936;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.Qeyw02._1672133261;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.Qeyw02._1672133261)
          by smtp.aliyun-inc.com;
          Tue, 27 Dec 2022 17:27:42 +0800
Date:   Tue, 27 Dec 2022 17:27:43 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Subject: Re: queue-6.1 drop perf-stat-display-event-stats-using-aggr-counts.patch please
Cc:     stable@vger.kernel.org
In-Reply-To: <Y6qjQXB626ZnaSjw@kroah.com>
References: <20221227082544.AC63.409509F4@e16-tech.com> <Y6qjQXB626ZnaSjw@kroah.com>
Message-Id: <20221227172742.10DE.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> On Tue, Dec 27, 2022 at 08:25:45AM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > drop perf-stat-display-event-stats-using-aggr-counts.patch
> > from queue-6.1 please.
> > 
> > It failed to compile on 6.1.y now.
> 
> Why not just also queue up b89761351089 ("perf stat: Update event skip
> condition for system-wide per-thread mode and merged uncore and hybrid
> events")?

We could add 
ca68b374d040 (perf stat: Add struct perf_stat_aggr to perf_stat_evsel)

to queue-6.1 before the patch 'perf-stat-display-event-stats-using-aggr-counts.patch'

to fix the build error.
util/stat-display.c: In function 'print_counter_aggrdata':
util/stat-display.c:690:35: error: 'struct perf_stat_evsel' has no member named 'aggr'
  struct perf_stat_aggr *aggr = &ps->aggr[s];

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2022/12/27

> thanks,
> 
> greg k-h


