Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867CA44FE87
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 07:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhKOGEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 01:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhKOGEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 01:04:37 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D911EC0613B9;
        Sun, 14 Nov 2021 22:01:41 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id bu18so40680062lfb.0;
        Sun, 14 Nov 2021 22:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=rE3n8ewSQTA1WhktnlAlSMmD91ffVaRf6It50caE7gE=;
        b=BIJEge6NiFp9hJvkJWZopOSnSOODWyIoO9Wo/x5CMgvb4dAVHwubVw2w+KPCTT71YR
         7STG2kpODR1iTyC3s+tyHwkXDCWb06PTRiXaNuHmIARYTlR5DB5z9RjQ2sWEe6cuJqDZ
         zbcVKRM1fVbm4d2Dw69hCv39Dw47GGDcTwPqbSmF4CGcLwa3eCChU9KVQ8NANUN2mEcH
         m771LeSD1J1FVTNEr3bDhZxeECczQV+8gngxUPp8HDttRMw6JM08emT3B5jtgxK3oDJB
         gFs+YtE8u9vXnQ1AosEVgEZ6ro3jsxm/nk1O2Ss9fxpv4abPTP+AGVBtgse111IYTnSp
         mLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=rE3n8ewSQTA1WhktnlAlSMmD91ffVaRf6It50caE7gE=;
        b=4mf58Gn9VhMnd+IYMH/lJxW2xqhr4pOWBNxxgS0HC7pown1IcKZ2anV2NnTHmuXr+n
         jTckVdKtnuK8M+IHi1IihEQRB49CZVkx5Tu3RBFg+NOgzJ+TehkG7cqooQ2mWlNKt3nL
         iwBBWTi/SsQsz8Jv3hhvPBOoj36xEKfpuAWWG0je1cw1UB92oP/X65CIE3i0XejUchhP
         CYFAeQWuC7oQhkCMo+zTXcS0VV6fsKb3lYBO6TfvwEYftqkRd9hhmxBZtt8HcCfVvI+i
         a109jgzgxMIIyI9Td8n9qoFjm6DRXPIBJ2I3uO7KsU3D7Ie94aCyuXoFTLjHutkVEW4q
         EQwQ==
X-Gm-Message-State: AOAM5312HbWtcDp3dKU+i0UHI86EpKwIgDOhZSyh1xiCZBdhVNs8dfvl
        1kT0XNK5AC69YTE57YcrzH6RCJIDZbHtJegRH6kHiYXpe38=
X-Google-Smtp-Source: ABdhPJwyQ1qHjpsctfdy+ZfPQjknqFskYXg0aC0H5HAw9nCK/HhfYjPRT5PG6cWnQKfVwKWDFhCVUr1XXFPcET9gAzw=
X-Received: by 2002:ac2:5ddb:: with SMTP id x27mr32277423lfq.595.1636956099911;
 Sun, 14 Nov 2021 22:01:39 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 15 Nov 2021 00:01:29 -0600
Message-ID: <CAH2r5msbc9A0V2qh2Prx4WSNsDAWp4m5Sj76YgKN8Qb7fWbZdw@mail.gmail.com>
Subject: smb3: do not error on fsync when readonly
To:     Stable <stable@vger.kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Julian Sikorski <belegdol@gmail.com>,
        Jeremy Allison <jra@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please include "smb3: do not error on fsync when readonly"

Commit id:
71e6864eacbef0b2645ca043cdfbac272cb6cea3

It fixes an fsync problem over SMB3 mounts, reported by Julian, when
the file is not opened for write.
-- 
Thanks,

Steve
