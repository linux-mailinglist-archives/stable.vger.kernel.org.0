Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD5649F23D
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 20:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbfH0SVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 14:21:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55917 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbfH0SVx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 14:21:53 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22E8F18C891C
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 18:21:53 +0000 (UTC)
Received: from localhost.localdomain (ovpn-120-245.rdu2.redhat.com [10.10.120.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D133060632;
        Tue, 27 Aug 2019 18:21:46 +0000 (UTC)
To:     Linux Stable maillist <stable@vger.kernel.org>
Cc:     CKI Project <cki-project@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Subject: [INFO] Testing LTP directly from github
Message-ID: <122d7241-86b1-f750-ace3-37378a29ea1c@redhat.com>
Date:   Tue, 27 Aug 2019 14:21:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Tue, 27 Aug 2019 18:21:53 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

The CKI team will be updating the current LTP version to fetch directly 
from GitHub using a recent stable
commit.

We were previously using the latest stable release (20190517), however 
we would like to use a later version
of LTP to encourage more upstream LTP collaboration. Newer releases pull 
in recent test case fixes and help
us find more kernel bugs. :-)

The test will initially be set to the waived status until we trust that 
it's going to be stable enough to
run in the pipeline. We will continue to monitor the progress, but 
wanted to make you aware of
these changes.

- Rachel
