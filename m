Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B1727DCBA
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 01:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgI2XfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 19:35:06 -0400
Received: from ma1-aaemail-dr-lapp03.apple.com ([17.171.2.72]:52200 "EHLO
        ma1-aaemail-dr-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726637AbgI2XfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 19:35:06 -0400
X-Greylist: delayed 9537 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2020 19:35:05 EDT
Received: from pps.filterd (ma1-aaemail-dr-lapp03.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp03.apple.com (8.16.0.42/8.16.0.42) with SMTP id 08TKrx7f037958;
        Tue, 29 Sep 2020 13:56:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=to : cc : from :
 subject : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=20180706;
 bh=hwbAYNKOdwXRdT2BWJo4hDVnnOeiZHos5vUGljLHDEI=;
 b=q7yDFPC2wKWB2TbAVcjF3Eh2KlvulVUvgIH9IWV70aE60MbcBH9aorbrPWTLZ3HO4oay
 Rivo6rUI86lRpMiU4F+uOamjm1ntnwC88k++W/IEg5vk0Q2ERLyM5iUdr0EAPMuFnz5t
 OmbldSmJSJ4p/86F9Mol9IMvlO7SRwZ+Rks7SUK+pgIqP9fnPLTudOxJPTeviv/VZBZ/
 Qmu7zCPSokSu96tGqlZjPx/tjORbc5SjIoLCI1J4rfbmkFMy1GY8S1Df8hskM20MlP1B
 3uYuRcyBBhhKDQubOLK/wcjJWk/arasHrRQTNIvTPWYYfuSV+6mp97I4tAdgtCVvxaSj fA== 
Received: from rn-mailsvcp-mta-lapp04.rno.apple.com (rn-mailsvcp-mta-lapp04.rno.apple.com [10.225.203.152])
        by ma1-aaemail-dr-lapp03.apple.com with ESMTP id 33t4mur2xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 29 Sep 2020 13:56:07 -0700
Received: from rn-mailsvcp-mmp-lapp01.rno.apple.com
 (rn-mailsvcp-mmp-lapp01.rno.apple.com [17.179.253.14])
 by rn-mailsvcp-mta-lapp04.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020)) with ESMTPS id <0QHF00VDQU1Z4JA0@rn-mailsvcp-mta-lapp04.rno.apple.com>;
 Tue, 29 Sep 2020 13:53:59 -0700 (PDT)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp01.rno.apple.com by
 rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020)) id <0QHF00M00T4XOG00@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Tue,
 29 Sep 2020 13:53:59 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: a7df34be26ac7dd9260bc16392ad79bf
X-Va-E-CD: cdbd4e8ba158a4eeb1086510058b468d
X-Va-R-CD: b09c8571ca93436fe02decf8e7b2fa5a
X-Va-CD: 0
X-Va-ID: 97ac0b7e-bb44-457f-b077-1610cb62652f
X-V-A:  
X-V-T-CD: a7df34be26ac7dd9260bc16392ad79bf
X-V-E-CD: cdbd4e8ba158a4eeb1086510058b468d
X-V-R-CD: b09c8571ca93436fe02decf8e7b2fa5a
X-V-CD: 0
X-V-ID: 2ff10da3-3a89-4871-88a4-82f3fa6ff18d
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
Received: from [17.149.214.207] (unknown [17.149.214.207])
 by rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020))
 with ESMTPSA id <0QHF00CJ1U1ZH600@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Tue,
 29 Sep 2020 13:53:59 -0700 (PDT)
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Andrew Forgue <andrewf@apple.com>
From:   Vishnu Rangayyan <vrangayyan@apple.com>
Subject: vsock fix for 5.4 stable
Message-id: <4871038a-6ab7-4c44-875c-2d04012de34a@apple.com>
Date:   Tue, 29 Sep 2020 13:53:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can we have this backport applied to 5.4 stable, its more of a required 
fix than an enhancement.

commit df12eb6d6cd920ab2f0e0a43cd6e1c23a05cea91 upstream

The call has a minor api change in 5.4 vs higher, only the pkt arg is 
required.

diff --git a/net/vmw_vsock/virtio_transport_common.c 
b/net/vmw_vsock/virtio_transport_common.c
index d9f0c9c5425a..2f696124bab6 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1153,6 +1153,7 @@ void virtio_transport_recv_pkt(struct 
virtio_transport *t,
  		virtio_transport_free_pkt(pkt);
  		break;
  	default:
+		(void)virtio_transport_reset_no_sock(pkt);
  		virtio_transport_free_pkt(pkt);
  		break;
  	}
-- 
