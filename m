Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9B215BC01
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 10:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgBMJta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 04:49:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39310 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgBMJta (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 04:49:30 -0500
Received: from 1.general.smb.uk.vpn ([10.172.193.28] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <stefan.bader@canonical.com>)
        id 1j2B7g-00050p-Tj; Thu, 13 Feb 2020 09:49:29 +0000
From:   Stefan Bader <stefan.bader@canonical.com>
To:     stable@vger.kernel.org, snitzer@redhat.com
Subject: Backports 4.14, 4.9, 4.4: dm: fix potential for q->make_request_fn NULL pointer
Date:   Thu, 13 Feb 2020 10:49:25 +0100
Message-Id: <20200213094928.30487-1-stefan.bader@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following are the backports into the 3 stable trees mentioned. Unfortunately
context required ajustments for each tree. Mike, I would appreciate if you
could glance over those to double check. Thanks.

-Stefan

