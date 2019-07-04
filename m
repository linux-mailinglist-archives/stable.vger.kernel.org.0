Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF285F7DC
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 14:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbfGDMTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 08:19:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52430 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727643AbfGDMTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 08:19:25 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9D70D87628
        for <stable@vger.kernel.org>; Thu,  4 Jul 2019 12:19:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94E56379C
        for <stable@vger.kernel.org>; Thu,  4 Jul 2019 12:19:25 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8A83019720;
        Thu,  4 Jul 2019 12:19:25 +0000 (UTC)
Date:   Thu, 4 Jul 2019 08:19:25 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Message-ID: <1057508448.28699407.1562242765522.JavaMail.zimbra@redhat.com>
In-Reply-To: <974176438.28699281.1562242595285.JavaMail.zimbra@redhat.com>
Subject: CKI results for yesterday's early today's 4.19 and 5.1 queues
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.205.43, 10.4.195.12]
Thread-Topic: CKI results for yesterday's early today's 4.19 and 5.1 queues
Thread-Index: 3kIjTuCR8QHfCiejoKDvqAVkhoOOpw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 04 Jul 2019 12:19:25 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Hi,

we encountered an issue that blocked us from sending out proper reports for
some pipelines so I want to make sure the results get sent out.

In that time, we tested:

stable linux-5.1.y:8584aaf1c326
stable linux-5.1.y:57f5b343cdf9

queue-4.19 c775271c438ccaad33f025bb5027c573bd7d8c35
queue-4.19 d13157b55a88eed3505bb42a249dd721d2837cff
queue-4.19 715a0203f375147f679bb92e052676380efadcff

queue-5.1 715a0203f375147f679bb92e052676380efadcff
queue-5.1 d13157b55a88eed3505bb42a249dd721d2837cff


All of the testing passed. The regular set of tests was executed with all
of these.


Sorry for the inconvenience and lack of the usual reports,
Veronika
