Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A4F25AFB0
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 17:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgIBPnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 11:43:55 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41616 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgIBPnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 11:43:52 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: wlozano)
        with ESMTPSA id 6415229AAD6
To:     stable@vger.kernel.org
From:   Walter Lozano <walter.lozano@collabora.com>
Subject: Stable inclusion request 5.4: GPU hangs fixes for etnaviv
Message-ID: <232e3634-f82a-4db3-3427-701240b77ecf@collabora.com>
Date:   Wed, 2 Sep 2020 12:43:45 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Could you please cherry-pick these ones to Linux 5.4

Commit: f232d9ec029ce3e2543b05213e2979e01e503408
Author: Lucas Stach <l.stach@xxxxxxxxxxxxxxxxx>
Date: Wed, 26 Feb 2020 16:27:08 +0100

Commit: d7c5782acd354bdb5ed0fa10e1e397eaed558390
Author: Andrey Grodzovsky <andrey.grodzovsky@xxxxxxxxxxxxxxxxx>
Date: Tue, 29 Oct 2019 11:03:05 -0400

These patches fixes GPU hangs using etnaviv driver.

Regards,

Walter

