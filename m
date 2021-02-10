Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A4E316AAF
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 17:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhBJQFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 11:05:03 -0500
Received: from mail.efficios.com ([167.114.26.124]:40234 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhBJQFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 11:05:01 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id D95B32FD1BE;
        Wed, 10 Feb 2021 11:04:19 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id eLTiJ4R0sY9Z; Wed, 10 Feb 2021 11:04:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 83EDD2FD602;
        Wed, 10 Feb 2021 11:04:19 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 83EDD2FD602
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1612973059;
        bh=+UBxwqbweM8A4Z+cPBFhpP7uEXxPrvJF/TprvOtzmiQ=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=CDh9rPPiWjTvcCAs2MU6LC/2zjxtSYl2lCDVBHuQ6pnvud/NBBj6QRoGlNxvVxj3T
         6ElF5NaB8q24BCuTWtpIMWS8Y7kMzT0a6ipV0cG74DBNhFOuF7aNSrtxwmJ++TkkAE
         16rF28KymIepHCQy2N9DiXwhncLiWsXYjVpX9uBAwPkHl22EfSDEysYprIwPt2iFtr
         qfmrV4IqjqkonR8laUeq7kM/ZATUdNPtstmLzoI0AW4ScAaHEtHB0+l0SO79yTfcHx
         bFO9g5txLdABF2E5FEzvw85BMb1NPPZnnkED7i0nfJI2s3QmLdyox9lXy9x9yjYCwp
         W821/BPnbHHlg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 17KkZ-M1c7Xo; Wed, 10 Feb 2021 11:04:19 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 741DB2FD328;
        Wed, 10 Feb 2021 11:04:19 -0500 (EST)
Date:   Wed, 10 Feb 2021 11:04:19 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     stable <stable@vger.kernel.org>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rostedt <rostedt@goodmis.org>,
        Michael Jeanson <mjeanson@efficios.com>
Message-ID: <537870616.15400.1612973059419.JavaMail.zimbra@efficios.com>
Subject: [stable 4.4, 4.9, 4.14, 4.19 LTS] Missing fix "memcg: fix a crash
 in wb_workfn when a device disappears"
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3996 (ZimbraWebClient - FF85 (Linux)/8.8.15_GA_3996)
Thread-Index: 4Jv7RqCdiKag+0YuCj6QoeuUQYax/Q==
Thread-Topic: Missing fix "memcg: fix a crash in wb_workfn when a device disappears"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

While reconciling the lttng-modules writeback instrumentation with its counterpart
within the upstream Linux kernel, I notice that the following commit introduced in
5.6 is present in stable branches 5.4 and 5.5, but is missing from LTS stable branches
for 4.4, 4.9, 4.14, 4.19:

commit 68f23b89067fdf187763e75a56087550624fdbee
("memcg: fix a crash in wb_workfn when a device disappears")

Considering that this fix was CC'd to the stable mailing list, is there any
reason why it has not been integrated into those LTS branches ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
