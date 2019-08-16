Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B71B890592
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 18:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfHPQPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 12:15:23 -0400
Received: from dougal.metanate.com ([90.155.101.14]:32341 "EHLO metanate.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726097AbfHPQPW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 12:15:22 -0400
X-Greylist: delayed 918 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2019 12:15:17 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/simple; d=metanate.com;
         s=stronger; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID
        :Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=koNAAtDIYV3MYRdTVRV262L1pB+QGxj2Fu2A7LHmRxk=; b=X2lcGog7WDFZ1XQ6Akcii9J4aV
        itt0LcpJbLoXddZuLCpBGLbDeyPp1RjCOpEfD4JnvzCJKpvMYCPU7n6eE2uMyD/iqppPcs8WhNHTT
        kny4P1ax5pCGyMDlFTQ/nlgKAt2ksZfr68zUdFqdBv8e491DCB8iaJc1b9kGCvTvE04n8cFrYN9Ql
        F1RAVBmIFg0HyND0UyDG9BdqNPwIhOU4FSh3gHaFR6TnObgNd7tfCtwStfFzR6kYgjQ9LKq+7zcfv
        h08gDYMmiCsUM+IgArykUQCFooOPT7JDMK2D27Y6/XIpIPxG4nEk8c9rOXfWliuD4fbYaJmHrOUgT
        s5zR99eg==;
Received: from dougal.metanate.com ([192.168.88.1] helo=donbot)
        by shrek.metanate.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <john@metanate.com>)
        id 1hyedx-0001D0-M5
        for stable@vger.kernel.org; Fri, 16 Aug 2019 16:59:57 +0100
Date:   Fri, 16 Aug 2019 16:59:55 +0100
From:   John Keeping <john@metanate.com>
To:     stable@vger.kernel.org
Subject: Backport c289d6625237 ("Revert "pwm: Set class for exported
 channels in sysfs"") to 4.19
Message-ID: <20190816165955.3555cfed.john@metanate.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated: YES
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please consider backporting commit c289d6625237 ("Revert "pwm: Set class
for exported channels in sysfs"") from 4.20 to 4.19 stable (the original
buggy commit was introduced in 4.16).

This one-line revert fixes an oops triggered by writing to sysfs.


Thanks,
John
