Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45067294E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 09:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbfGXHwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 03:52:46 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:39793 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfGXHwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 03:52:46 -0400
Received: by mail-lj1-f182.google.com with SMTP id v18so43531571ljh.6
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 00:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=TcViZhHesHKkWwq0liIXgZOEqVRP8g68ct9Q5F8kIGs=;
        b=ghJ+IZQURlIR7oaHsY+6YpwYXTKQ6BBvYxaDmrxupBNuNZSJLAtBwkXdJdzw1NfWYw
         IhAyci95IYaLW8zKU+u9yoMIDXSOY9qwn+9YlUM+2ufdKR919e881F3G3touCd1ICt54
         ucOdm1nzC0HTdLRJFySLw/O8xgZnq1OJqKojCQy0mbGL4N99VXALyEVwh8qbpZC4akdL
         D/whu71ShygfzudVyn9BNnYJsklFt6aXH7ohR3RE09sgx7IqrpfYGnSzujgmWA2Jp///
         yM8ZvRtswEhOn7uLiHxfIvs1HGsuMhVxlyFqNkEE6JpPoAn2qwY5Me9pCpidITsmtvJz
         w3sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=TcViZhHesHKkWwq0liIXgZOEqVRP8g68ct9Q5F8kIGs=;
        b=U2BxPqSHkpFAMFfgxqGnBjOrukXbls5rsbJ4Cw1zrWJa23UOufKRmcV1qDy3fC+fC2
         80OPx+vSW2zlkTG1VTL25EHmUmtaDJ5vDoo4fbRaEfJ06OEqmYwck1gqRt18KHOZKUPB
         fUqIeoXrDTE563ms35yiCZs3GRGUE6LFX3SKq1mJpYgxsCWhU2IOan2VWHSjpnYHDQ1c
         Jx2HGzjqiUkE80H4tA7/SLwY+5NJWRLbE5guN1hsIBIKpWCN4nXOWFmGqgJN08LvgLL5
         Ft2yZ8hkG/8jjgjylnheh4XkuZ7YFKEtMa/cyKmrVMRsN+Rkp8LkkGl7xRduBah+KII7
         pDyw==
X-Gm-Message-State: APjAAAXZ0C5A1QCWhq+65nHEkEOOPLdag2IfOpnYYtnUI3yv81hujrgw
        snoL0vkgA20FX9LpK81ct/svEBACSe4kOk/VY4u0ewA8CYY=
X-Google-Smtp-Source: APXvYqxXDKHKVHnBerN2mEgFUHW/Jh8Lk6sZdC1yK4vmvzE+5pPnNRGwEwPGijjjdeoOsETepiqBp09KA8n3rAfuY3k=
X-Received: by 2002:a2e:6e0c:: with SMTP id j12mr41814717ljc.123.1563954764047;
 Wed, 24 Jul 2019 00:52:44 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Jul 2019 13:22:33 +0530
Message-ID: <CA+G9fYt3sCcazODJodtrJUsLDKusaMx1NWeM03hyrgcSVGUM8Q@mail.gmail.com>
Subject: stable-rc 4.14: i386 and armv7 builds failed
To:     linux- stable <stable@vger.kernel.org>, jthumshirn@suse.de,
        dsterba@suse.com, nborisov@suse.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable rc 4.14 stable rc i386 and armv7 builds failed due to below error.

fs/btrfs/file.c: In function 'btrfs_punch_hole':
fs/btrfs/file.c:2787:27: error: invalid initializer
   struct timespec64 now = current_time(inode);
                           ^~~~~~~~~~~~
fs/btrfs/file.c:2790:18: error: incompatible types when assigning to
type 'struct timespec' from type 'struct timespec64'
   inode->i_mtime = now;
                   ^
fs/btrfs/file.c:2791:18: error: incompatible types when assigning to
type 'struct timespec' from type 'struct timespec64'
   inode->i_ctime = now;
                  ^

Best regards
Naresh Kamboju
