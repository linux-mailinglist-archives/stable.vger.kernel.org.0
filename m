Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D72E1625E8
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 13:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgBRMH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 07:07:26 -0500
Received: from mail.itouring.de ([188.40.134.68]:50520 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbgBRMH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 07:07:26 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Feb 2020 07:07:25 EST
Received: from tux.applied-asynchrony.com (p5B07E2B3.dip0.t-ipconnect.de [91.7.226.179])
        by mail.itouring.de (Postfix) with ESMTPSA id E6DB9416CB45
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 13:01:40 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 9FF16F01606
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 13:01:40 +0100 (CET)
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: 5.4-stable request: 52e29e331070cd ('btrfs: don't set
 path->leave_spinning for truncate')
Organization: Applied Asynchrony, Inc.
Message-ID: <e56ac6c0-2bae-62a1-a22d-d7374a98ab43@applied-asynchrony.com>
Date:   Tue, 18 Feb 2020 13:01:40 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I was just looking throught the current 5.4-stable queue and saw that
28553fa992cb28 ('Btrfs: fix race between shrinking truncate and fiemap')
is queued. Upstream has a follow-up fix for this: 52e29e331070cd aka
'btrfs: don't set path->leave_spinning for truncate'.

Would be nice to get those in together. I only looked at 5.4, don't
know about other queues.

thanks,
Holger
