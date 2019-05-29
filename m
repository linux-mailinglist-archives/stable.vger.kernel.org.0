Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4252DDD3
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 15:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfE2NOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 09:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfE2NOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 09:14:53 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43F372081C;
        Wed, 29 May 2019 13:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559135692;
        bh=xKlA2g0wIi0S7QT1ghsj/kNXtl6yCp86bG8AATUDAzk=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=AVJjj8POoTrQ4M7YeIyqLpk553l1+dSgSikMjhX+vYUMNAKXNliKLQQGPNBYstW1w
         XZ4o/uG+HMJljqzFV5GehPQSqkLoa0zd+dKCy0bWBzv0W6KDjCogzb6hg8X4rWbCyc
         nfDQzzou7D2nvunV+KUtGTpA/cXDRyO+nSg72EL0=
Date:   Wed, 29 May 2019 13:14:51 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 8/8] ceph: hold i_ceph_lock when removing caps for freeing inode
In-Reply-To: <20190523080646.19632-8-zyan@redhat.com>
References: <20190523080646.19632-8-zyan@redhat.com>
Message-Id: <20190529131452.43F372081C@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.1.4, v5.0.18, v4.19.45, v4.14.121, v4.9.178, v4.4.180, v3.18.140.

v5.1.4: Build OK!
v5.0.18: Failed to apply! Possible dependencies:
    e3ec8d6898f71 ("ceph: send cap releases more aggressively")

v4.19.45: Failed to apply! Possible dependencies:
    e3ec8d6898f71 ("ceph: send cap releases more aggressively")

v4.14.121: Failed to apply! Possible dependencies:
    a1c6b8358171c ("ceph: define argument structure for handle_cap_grant")
    a57d9064e4ee4 ("ceph: flush pending works before shutdown super")
    e3ec8d6898f71 ("ceph: send cap releases more aggressively")

v4.9.178: Failed to apply! Possible dependencies:
    a1c6b8358171c ("ceph: define argument structure for handle_cap_grant")
    a57d9064e4ee4 ("ceph: flush pending works before shutdown super")
    e3ec8d6898f71 ("ceph: send cap releases more aggressively")

v4.4.180: Failed to apply! Possible dependencies:
    13d1ad16d05ee ("libceph: move message allocation out of ceph_osdc_alloc_request()")
    34b759b4a22b0 ("ceph: kill ceph_empty_snapc")
    3f1af42ad0fad ("libceph: enable large, variable-sized OSD requests")
    5be0389dac662 ("ceph: re-send AIO write request when getting -EOLDSNAP error")
    7627151ea30bc ("libceph: define new ceph_file_layout structure")
    779fe0fb8e188 ("ceph: rados pool namespace support")
    922dab6134178 ("libceph, rbd: ceph_osd_linger_request, watch/notify v2")
    a1c6b8358171c ("ceph: define argument structure for handle_cap_grant")
    ae458f5a171ba ("libceph: make r_request msg_size calculation clearer")
    c41d13a31fefe ("rbd: use header_oid instead of header_name")
    c8fe9b17d055f ("ceph: Asynchronous IO support")
    d30291b985d18 ("libceph: variable-sized ceph_object_id")
    e3ec8d6898f71 ("ceph: send cap releases more aggressively")

v3.18.140: Failed to apply! Possible dependencies:
    10183a69551f7 ("ceph: check OSD caps before read/write")
    28127bdd2f843 ("ceph: convert inline data to normal data before data write")
    31c542a199d79 ("ceph: add inline data to pagecache")
    5be0389dac662 ("ceph: re-send AIO write request when getting -EOLDSNAP error")
    70db4f3629b34 ("ceph: introduce a new inode flag indicating if cached dentries are ordered")
    745a8e3bccbc6 ("ceph: don't pre-allocate space for cap release messages")
    7627151ea30bc ("libceph: define new ceph_file_layout structure")
    779fe0fb8e188 ("ceph: rados pool namespace support")
    83701246aee8f ("ceph: sync read inline data")
    a1c6b8358171c ("ceph: define argument structure for handle_cap_grant")
    affbc19a68f99 ("ceph: make sure syncfs flushes all cap snaps")
    c8fe9b17d055f ("ceph: Asynchronous IO support")
    d30291b985d18 ("libceph: variable-sized ceph_object_id")
    d3383a8e37f80 ("ceph: avoid block operation when !TASK_RUNNING (ceph_mdsc_sync)")
    e3ec8d6898f71 ("ceph: send cap releases more aggressively")
    e96a650a8174e ("ceph, rbd: delete unnecessary checks before two function calls")


How should we proceed with this patch?

--
Thanks,
Sasha
