Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2E521A28D
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 16:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgGIOxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 10:53:39 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:59316 "EHLO
        mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgGIOxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 10:53:38 -0400
X-Greylist: delayed 1101 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jul 2020 10:53:38 EDT
X-ASG-Debug-ID: 1594305312-0fb3b01c5827c570001-OJig3u
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id rPPfTzpDFp0QNXka; Thu, 09 Jul 2020 10:35:13 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-ASG-Whitelist: Client
Received: from [10.157.2.224] (account tonyb HELO [192.168.200.1])
  by cybernetics.com (CommuniGate Pro SMTP 5.1.14)
  with ESMTPSA id 10089887; Thu, 09 Jul 2020 10:35:12 -0400
To:     stable <stable@vger.kernel.org>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Chris Mason <clm@fb.com>, Guenter Roeck <linux@roeck-us.net>,
        Christoph Hellwig <hch@lst.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Jens Axboe <axboe@kernel.dk>
From:   Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] block: fix splitting segments on boundary masks
Message-ID: <94114379-78f6-6465-49de-99aa5b3f4d0d@cybernetics.com>
X-ASG-Orig-Subj: Re: [PATCH] block: fix splitting segments on boundary masks
Date:   Thu, 9 Jul 2020 10:35:14 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1594305313
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 1110
X-Barracuda-BRTS-Status: 1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Although I was not originally involved in the development of these
patches, I recently came across them while looking over the source:

upstream commit 429120f3df2d ("block: fix splitting segments on boundary masks")
    Cc: stable@vger.kernel.org # v5.1+
    Fixes: dcebd755926b ("block: use bio_for_each_bvec() to compute multi-page bvec count")

upstream commit 4a2f704eb2d8 ("block: fix get_max_segment_size() overflow on 32bit arch")
    Fixes: 429120f3df2d ("block: fix splitting segments on boundary masks")

https://www.spinics.net/lists/linux-block/msg48605.html
https://www.spinics.net/lists/linux-block/msg48959.html


The first patch mentions fixing problems with filesystem corruption, so
it seems important, but it has never been included in any -stable
kernel.  Is there a specific reason these patches have been excluded
from -stable, or is it just a mistake?

These patches would be relevant to kernel versions 5.1 - 5.4, with 5.4.y
being the only active stable kernel series in that range.  The patches
apply cleanly on top of 5.4.51.

Tony Battersby
Cybernetics

