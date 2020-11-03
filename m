Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D942A4CCB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 18:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgKCRZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 12:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbgKCRZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 12:25:08 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42648C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 09:25:07 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id c18so2668306ybj.10
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 09:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=w/YBkuksp//XQvuBBwpNQCy5X0a3sDuYBHfRuuDRsbs=;
        b=CQ2eOes+WqURaysP8cdpXG4YFGeCWoViBHyfdY1D+DrAJG2KipzOgjlkym9B29XuG3
         jtpSyyOvpWvOZRa+D1zim8G4TvCkNakWiObB8RhO+G0SxOOC8zqK3HSaEgzjs2MO63b9
         WTc2N/Xq9hFxu6/I75fcZ/laZc93zNojVbKIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=w/YBkuksp//XQvuBBwpNQCy5X0a3sDuYBHfRuuDRsbs=;
        b=oXDkqct6c7/Qu3fw3QHjNMkt7MDhOsOICgzw8l6EuAxobj4I07TN+t8eTquagh/9yN
         8xYKQDPK0SlvTBeWYQLe2UNXmfeKfISrYBfEltS9ZAnQ6y4P+6zqDEPfpj/VW467Dn2l
         g+jVCjgOJ9lwQsLdsChS55Z3PS51fS+tVk8HofRLsKAUL2mYYQWDO2Ka8zI169VGax8r
         BFlU4NabzmsrXhZ1yE69YOJuNJB42nDQBdgvM63lBnh2bloPVOta8xwmwP4pbwrovs9l
         3w782cmivXUxrnSGHxAcj3Z+3kMQ7nW5HKDjZpwcvMemZjNArI8RAiQWOGGBxxp+7LfY
         98yg==
X-Gm-Message-State: AOAM530RlkdAtusu611wtJnjj5r4zzPvq/iuvulBz1z750KvuAxKBXwN
        gT37CUPt93EzOQIVxJwjtL8h0S3HNoQPbsk/DnzYIQwGTOI=
X-Google-Smtp-Source: ABdhPJzLra9yCX1TyYvoVNFY0cgXQlbQpCrWeKqrDL643M1sQ9Y2WXkGqA9SrVW97xuE5WMdmm6YW6AOeh9y8vMbJzg=
X-Received: by 2002:a25:5c85:: with SMTP id q127mr29781010ybb.413.1604424306151;
 Tue, 03 Nov 2020 09:25:06 -0800 (PST)
MIME-Version: 1.0
References: <CAABuPhZKJncNoVb3-um8WTdyvffvcYqPKDUA_AcpmEZQrMshTg@mail.gmail.com>
In-Reply-To: <CAABuPhZKJncNoVb3-um8WTdyvffvcYqPKDUA_AcpmEZQrMshTg@mail.gmail.com>
From:   Costa Sapuntzakis <costa@purestorage.com>
Date:   Tue, 3 Nov 2020 09:24:57 -0800
Message-ID: <CAABuPhZZG13uxa-NpiH1k1HbNYx2QDLEOLURsVnBmu8ynZcaig@mail.gmail.com>
Subject: Fwd: remove ext4-fix-superblock-checksum-calculation-race.patch ?
To:     stable@vger.kernel.org, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot found https://syzkaller.appspot.com/bug?extid=7a4ba6a239b91a126c28
which shows we can try to sleep under a spinlock in an error path.

-Costa
