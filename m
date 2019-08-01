Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B517D5F2
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 09:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbfHAHAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 03:00:43 -0400
Received: from zimbra2.kalray.eu ([92.103.151.219]:53434 "EHLO
        zimbra2.kalray.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729561AbfHAHAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 03:00:43 -0400
Received: from localhost (localhost [127.0.0.1])
        by zimbra2.kalray.eu (Postfix) with ESMTP id 9E5E12A220F2;
        Thu,  1 Aug 2019 09:00:42 +0200 (CEST)
Received: from zimbra2.kalray.eu ([127.0.0.1])
        by localhost (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Cw1APTwWsgjd; Thu,  1 Aug 2019 09:00:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by zimbra2.kalray.eu (Postfix) with ESMTP id 60EDB2A220F4;
        Thu,  1 Aug 2019 09:00:42 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu 60EDB2A220F4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalray.eu;
        s=32AE1B44-9502-11E5-BA35-3734643DEF29; t=1564642842;
        bh=CBEBRa6if1RlZniU9G2W1G/yrU0I+pnHlL3TtuK1TkA=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=JahiLL3QV9FFxJM3RzJZ08k0DDp5lkjvW8LRVZmxrfo5WjyV2itYfWMQq2ot9lglC
         Y/kPXnphIKeIRhcMzJLZFJPSnDQm/tod1zi6FON/nC68DXwo7uFqQluuIFN2OPX77f
         epOymTVi/xCsEuHmKWkhATjWEjmkSDUOrtmVNUhI=
X-Virus-Scanned: amavisd-new at zimbra2.kalray.eu
Received: from zimbra2.kalray.eu ([127.0.0.1])
        by localhost (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 0rIMn2RndxHk; Thu,  1 Aug 2019 09:00:42 +0200 (CEST)
Received: from zimbra2.kalray.eu (zimbra2.kalray.eu [192.168.40.202])
        by zimbra2.kalray.eu (Postfix) with ESMTP id 4C58C2A220F2;
        Thu,  1 Aug 2019 09:00:42 +0200 (CEST)
Date:   Thu, 1 Aug 2019 09:00:42 +0200 (CEST)
From:   Marta Rybczynska <mrybczyn@kalray.eu>
To:     stable@vger.kernel.org
Cc:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me
Message-ID: <604962916.43493351.1564642842245.JavaMail.zimbra@kalray.eu>
Subject: Please include 66b20ac0a1a10769d059d6903202f53494e3d902 in 5.1 and
 5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.40.202]
X-Mailer: Zimbra 8.8.12_GA_3794 (ZimbraWebClient - FF57 (Linux)/8.8.12_GA_3794)
Thread-Index: lecSVHr5KX2l5cYYAtw599IBbRVmGw==
Thread-Topic: Please include 66b20ac0a1a10769d059d6903202f53494e3d902 in 5.1 and 5.2
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable maintainers,
Please include the commit 66b20ac0a1a10769d059d6903202f53494e3d902 into the stable 5.1 and 5.2.

Commit title: nvme: fix multipath crash when ANA is deactivated

The bug that this commit fixes was seen crashing kernels or provoking an oops from 5.0 onwards.

Regards,
Marta
