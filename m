Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5D9174540
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 06:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgB2Fc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 00:32:26 -0500
Received: from nwk-aaemail-lapp01.apple.com ([17.151.62.66]:56684 "EHLO
        nwk-aaemail-lapp01.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725747AbgB2Fc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 00:32:26 -0500
X-Greylist: delayed 33510 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Feb 2020 00:32:25 EST
Received: from pps.filterd (nwk-aaemail-lapp01.apple.com [127.0.0.1])
        by nwk-aaemail-lapp01.apple.com (8.16.0.27/8.16.0.27) with SMTP id 01SKCEcm039535;
        Fri, 28 Feb 2020 12:13:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from :
 content-type : content-transfer-encoding : mime-version : subject :
 message-id : date : cc : to; s=20180706;
 bh=GtN6g2I8C+yMxGFwx0O1X7XaKFL4fhIHZsN4zVKXgqo=;
 b=QsBdDO/p3X6Lsmqbwxhl1H7HWKZ63LSFtAYyW8LgzbqtgC5LGKEBl9Xcb7IQxnHdTvYf
 jNC/xwA7f9BlYZDq3KhAO6q5vI6Yjowu9YviupSZzBj+SGjVzL8mSBhm9Z8kN9mczICH
 a+StnPalv3/bfq6jVzW1RHPuPbS5RXdgiZobr2TDuCsK8bM9D/eOXmX39VRg6IejwZEm
 Iil7hLK3WQCKxXOQjj1UxuccVQpYygDnofQSuUrxPLcOI7PYdxh+oD06SsezkyLMnGur
 v8I4F1NHU6X+m6EPMRZlLmJIFioSwERKxyKXzjLrYUJB9/Xd2XEXYYKqpRZ1V0vsrxPn 4A== 
Received: from rn-mailsvcp-mta-lapp01.rno.apple.com (rn-mailsvcp-mta-lapp01.rno.apple.com [10.225.203.149])
        by nwk-aaemail-lapp01.apple.com with ESMTP id 2yeptvd3w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 28 Feb 2020 12:13:54 -0800
Received: from rn-mailsvcp-mmp-lapp01.rno.apple.com
 (rn-mailsvcp-mmp-lapp01.rno.apple.com [17.179.253.14])
 by rn-mailsvcp-mta-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.1.20190704 64bit (built Jul  4
 2019)) with ESMTPS id <0Q6F00JDZHJ662C0@rn-mailsvcp-mta-lapp01.rno.apple.com>;
 Fri, 28 Feb 2020 12:13:54 -0800 (PST)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp01.rno.apple.com by
 rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.1.20190704 64bit (built Jul  4
 2019)) id <0Q6F00400H4DCI00@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Fri,
 28 Feb 2020 12:13:54 -0800 (PST)
X-Va-A: 
X-Va-T-CD: e53dd95f2bfcdd4f3c9680ea5ad3fd94
X-Va-E-CD: 2d2068a9adf44f6654702d8ea314f551
X-Va-R-CD: 626fd568ec4e6f5aa3d08e31fc5dcc98
X-Va-CD: 0
X-Va-ID: e266933f-0635-4dff-add6-526355287bc4
X-V-A:  
X-V-T-CD: e53dd95f2bfcdd4f3c9680ea5ad3fd94
X-V-E-CD: 2d2068a9adf44f6654702d8ea314f551
X-V-R-CD: 626fd568ec4e6f5aa3d08e31fc5dcc98
X-V-CD: 0
X-V-ID: 2b3aea5d-76c9-4816-acc5-1d4018417b38
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_07:2020-02-28,2020-02-28 signatures=0
Received: from [17.149.214.249] (unknown [17.149.214.249])
 by rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.1.20190704 64bit (built Jul  4
 2019))
 with ESMTPSA id <0Q6F00VCZHJ6Z660@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Fri,
 28 Feb 2020 12:13:54 -0800 (PST)
From:   Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: quoted-printable
MIME-version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Fixes for 4.19 stable
Message-id: <6CF798B4-B68B-4729-A496-2152FC032ABC@apple.com>
Date:   Fri, 28 Feb 2020 12:13:54 -0800
Cc:     gregkh@linuxfoundation.org, Andrew Forgue <andrewf@apple.com>
To:     stable@vger.kernel.org
X-Mailer: Apple Mail (2.3608.60.0.2.5)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_07:2020-02-28,2020-02-28 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I still see high (upto 30%) ksoftirqd cpu use with 4.19.101+ after these =
2 back ports went in for 4.19.101
(had all 4 backports applied earlier to our tree):

commit f6783319737f28e4436a69611853a5a098cbe974 sched/fair: Fix =
insertion in rq->leaf_cfs_rq_list
commit 5d299eabea5a251fbf66e8277704b874bbba92dc sched/fair: Add =
tmp_alone_branch assertion

perf shows for any given ksoftirqd, with 20k-30k processes on the system =
with high scheduler load:
  58.88%  ksoftirqd/0  [kernel.kallsyms]  [k] update_blocked_averages

Can we backport these 2 also, confirmed that it fixes this behavior of =
ksoftirqd.

commit 039ae8bcf7a5f4476f4487e6bf816885fb3fb617 upstream
commit 31bc6aeaab1d1de8959b67edbed5c7a4b3cdbe7c upstream

The second one doesn=E2=80=99t apply cleanly, there=E2=80=99s a small =
change for the last diff, where pelt needs renaming to task =
(cfg_rq_clock_pelt was cfs_rq_clock_task in 4.19.y) in that unchanged =
part of the diff:

@@ -7700,10 +7720,6 @@ static void update_blocked_averages(int cpu)
 	for_each_leaf_cfs_rq(rq, cfs_rq) {
 		struct sched_entity *se;
=20
-		/* throttled entities do not contribute to load */
-		if (throttled_hierarchy(cfs_rq))
-			continue;
-
 		if (update_cfs_rq_load_avg(cfs_rq_clock_pelt(cfs_rq), =
cfs_rq))
 			update_tg_load_avg(cfs_rq, 0);


I can post that patch with that rename if required.

Thanks=20
Vishnu

