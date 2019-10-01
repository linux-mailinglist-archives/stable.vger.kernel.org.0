Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14AABC358F
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 15:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388313AbfJAN0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 09:26:20 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:40671 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388261AbfJAN0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 09:26:20 -0400
Received: by mail-io1-f53.google.com with SMTP id h144so47795801iof.7
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 06:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=eRiOfC6F6zKW8SxjHYwb3uoKvtDf9SQcgEmz6H1ratE=;
        b=uHnRnDC5JgJcB1GTMdj6fhda3JfWgH25o3MHWaxEUcXp8AZd5jweZoXnW874uJzxsb
         xkwyW8RGkH49ScWc8E97PkrmW9yLTiLaSNKDsJUmfjFSwKecpiNrs6sDAx6bLe6L/Ozh
         RT+cpNl7+0FeCtjmio6CN4gZbck9c0vd3/Wgk/l8Y1Gm4B5E9MgT5o94szcf0SdYn0Wr
         60PIlsZLM6cbaMjM/MNTDxkVORt+WJtBKSbF0NaNn8BsP1vNaHdLJZT56TfX1PvRY/ZU
         ctNqA7ddkZM8gQ+SGCXOynykFy22F609qNtCmXfZjDKMMaxTE3NrPR9E0syGt4EPhPwP
         7kCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=eRiOfC6F6zKW8SxjHYwb3uoKvtDf9SQcgEmz6H1ratE=;
        b=gnEaFnff13bHm7UFhOYcTlM/xV/q6gklUVwKHTdCTBs4ThaR1Sduam8rRt2t+f/UR2
         4xwmh2MgFqPTTVgCAtVosyfPDdyJRhb0MIdMXQGVRK0VwdWwY4gniA2+0UI/vnWQqCZL
         BtYJuAglVmVjlMqnhSd4tZTOw71YTtXi0wyLsmA05FgCleN0caAdOKr/pGoUmE5OrqZN
         vVzidpgKg3nwY8y/y0Tg6dvgHRn6clg8ryuUkuIfGUXHBODST8nm/omBG3Nl2R1PNpsZ
         jWK0L+HpQkXJ4ap7HkwYjaAPy5qkf8MjPzXQ5Lh5cyqkeIG6e1mp7QBKf8z7nQM2vmR/
         Krsw==
X-Gm-Message-State: APjAAAUUE0fg9aqHjQV1UqpvfcJepIgGcaPcu7uEGV6oLmxPOS+xjPGw
        wf/7ngIQXp+/oI+YDXoh+TZ74o0NrLCoSOJBJ11wj1A8sQI=
X-Google-Smtp-Source: APXvYqw9+i0TLUR+6zBe6MqEMFKNOpKur0xXRaTkV3tjxWUxctdexnzoeezdDpn5L1nQBwARgHriPLFwAoVqJTwBpDw=
X-Received: by 2002:a6b:b213:: with SMTP id b19mr4858832iof.58.1569936378582;
 Tue, 01 Oct 2019 06:26:18 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Ford <aford173@gmail.com>
Date:   Tue, 1 Oct 2019 08:26:07 -0500
Message-ID: <CAHCN7xKaSJWzZFQgdAzvnO_QEZtHDV4P3QJudhZDpCifmgHmKg@mail.gmail.com>
Subject: ARM: omap2plus_defconfig: Fix missing video
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply 4957eccf979b ("ARM: omap2plus_defconfig: Fix missing video")
to the 5.2, and 5.3 branches.

This fixes an issue where video is lost due to the removal of a driver
and its replacement was not enabled.

Thank you,

adam
