Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF08123C107
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 22:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgHDUxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 16:53:50 -0400
Received: from btbn.de ([5.9.118.179]:37642 "EHLO btbn.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727045AbgHDUxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Aug 2020 16:53:49 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2020 16:53:49 EDT
Received: from [IPv6:2001:16b8:64d7:4500:fc3b:cfd2:151e:7636] (200116b864d74500fc3bcfd2151e7636.dip.versatel-1u1.de [IPv6:2001:16b8:64d7:4500:fc3b:cfd2:151e:7636])
        by btbn.de (Postfix) with ESMTPSA id BA680189DF0
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 22:47:26 +0200 (CEST)
To:     stable@vger.kernel.org
From:   Timo Rothenpieler <timo@rothenpieler.org>
Subject: Backport request: nfsd: Fix NFSv4 READ on RDMA when using readv
Message-ID: <9cc28958-b715-5e51-e0c8-6f1821d2bfe0@rothenpieler.org>
Date:   Tue, 4 Aug 2020 22:47:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry if this is not the right approach to this, but I'd like to request 
a backport of 412055398b9e67e07347a936fc4a6adddabe9cf4, "nfsd: Fix NFSv4 
READ on RDMA when using readv" to Linux 5.4.

The patch applies cleanly and fixes a rare but severe issue with NFS 
over RDMA, which I just spent several days tracking down to that patch, 
with major help from linux-nfs/rdma.

I have right now manually applied it to my 5.4 Kernel and can confirm it 
fixes the issue.



Thanks,
Timo
