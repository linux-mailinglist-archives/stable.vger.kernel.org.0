Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628C533A291
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 05:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbhCNEHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 23:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhCNEHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 23:07:54 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B92C061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 20:07:54 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 12so1076006wmf.5
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 20:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lightbitslabs-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=UDlj4/23/i4glcl15X6jS0Xc5V7K2kYqhUfsnXtlOSU=;
        b=l1qsia39ZAHM+aTuhEWP412zmZ1yqx4d7XXw2wwf25DfTk1tuTSZY0U7yM1cnVO89U
         XYWr3mXPf3/3nrle5p3bTHiigQAQPEPRwtOjgkY5G7Ma/Sg2IAn8cm1+hhoLo4s+UlOo
         J+6Q0uJygDtXPEYcpzaYSmvUWf8b4p8dQV4TRhpno2Nx7cmiCXTNzl3+K3UojOH7IJXj
         a9/WTUkay85FkT6IkECeUoArb8VZXaXz3Vhu4oJExguspTOMagsj74zrXLuaLu0p+Gw/
         +VYaCMo/SV1VJQTyJxZOIAO7iI2lRqRusjynvQ7dmqbrw6UtabFNGtIQ0hTvedEiVmFl
         uHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=UDlj4/23/i4glcl15X6jS0Xc5V7K2kYqhUfsnXtlOSU=;
        b=LI3+7mG56eb2V7581F9fiEUf1A3e7TxS3ellCpVMLOUWOjPyuRf2uZR/TL3ZPEO8oh
         iKEHRbppKvJqnA5L1qHtcsNWxcVsWCkFv0OUlNF8/ScWdIiIhAyTHQnDAATsWP3f2pL0
         +j4t9fcXmThvPSO8nC93LymKnhWY6khZTY+eYgss2ymmwcgDt5LsHKi9BqnLSdXjnq+D
         II0bI2vLORLqAKNHNe7mIA2CecwpCCA9DpT2mo4kY6sXmk116nLOsaN0b4IwWPLJpHO0
         Te5XN2evvwbvycZVikcr6j/VYNzqadGjDdC1BuVZ1NqP9zg6ezYPp1LulOK8lTHeUMPO
         +ksA==
X-Gm-Message-State: AOAM533q/OMZc5owvnGqlPr5cNouKm4Txc8NergZ0AR8uri/2oOyE+av
        SQ40FjCERx5Awg7kgCv9J1cP0Iw2yk93HN3OvqueH9GN0vdS0I989mrlZuxAL/gk4Gn+7lrJoJ8
        mDZQR1SK4fbdKuWhZGA==
X-Google-Smtp-Source: ABdhPJz1e2jDMsovpddzD2OsH253c2RfX/P9ubBXUJPoZbbFJZJtECq0FC23OdotoLu81vpNLZF5HQ==
X-Received: by 2002:a05:600c:49aa:: with SMTP id h42mr20660291wmp.49.1615694872587;
        Sat, 13 Mar 2021 20:07:52 -0800 (PST)
Received: from anton-latitude..lbits ([98.42.3.175])
        by smtp.googlemail.com with ESMTPSA id l15sm14148746wru.38.2021.03.13.20.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 20:07:52 -0800 (PST)
From:   Anton Eidelman <anton@lightbitslabs.com>
To:     stable@vger.kernel.org
Cc:     kbusch@kernel.org, sagi@grimberg.me, hch@lst.de
Subject: nvme: ns_head vs namespace mismatch fixes
Date:   Sat, 13 Mar 2021 20:07:03 -0800
Message-Id: <20210314040705.1357858-1-anton@lightbitslabs.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please, apply the following two upstream commits (attached)
(in this order):
    d567572906d9 nvme: unlink head after removing last namespace
    ac262508daa8 nvme: release namespace head reference on error

TO: v5.4, v5.5, v5.6, v5.7
These commits are present in v5.8
and apply cleanly to the above.

Reason:
These fix a potential crash or malfunction
when an nvme namespace is deleted
and then a new namespace with the same nsid is created
before the old ns_head for this nsid is gone.

The first commit prevents the new namespace
from being matched by nvme_init_ns_head()
with the old ns_head causing ID mismatch
and consequently a failure to initialize the new namespace.

The second commit prevents ns_head refcount imbalance
in case nvme_init_ns_head() detects ID mismatch,
and consequently a crash later.

-- 


*Lightbits Labs**
*Lead the cloud-native data center
transformation by 
delivering *scalable *and *efficient *software
defined storage that is 
*easy *to consume.



*This message is sent in confidence for the addressee 
only.  It
may contain legally privileged information. The contents are not 
to be
disclosed to anyone other than the addressee. Unauthorized recipients 
are
requested to preserve this confidentiality, advise the sender 
immediately of
any error in transmission and delete the email from their 
systems.*

