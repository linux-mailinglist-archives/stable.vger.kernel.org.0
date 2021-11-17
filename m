Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7589E454086
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 06:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhKQGCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 01:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbhKQGCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 01:02:18 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A11CC061570;
        Tue, 16 Nov 2021 21:59:20 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id k2so3706986lji.4;
        Tue, 16 Nov 2021 21:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=AdflbgU09DTS4cJSjPs01SPy5ofGEDxZ50QAZbd+nRw=;
        b=qU7ZXxQfuZOxYot2xAK/keyezyqk8fuh2DshINXii3V1GMJzphjvY4eB8PtUqWLdg0
         LNz5upIW6Xmcc/CbGO0mW/1VfB0lp+pp3de8zems/Rn4Rrbizes24aPDt3VjpwDE9LV0
         /i5+gFdJpuUkvjBo7XmAdf3WKfvkiFwDEpAhh4E7Fr5VtIITlcckX9yVodeDg8veIzba
         8no5CGl21TIs46ZLb4q8OPKUKHv+g70KncmvEqUu+ceVM+0TfggGp9utHbXsuP/s8APG
         QA1LdT+i11nFNTi7mPkI8bL10vpx6fCP2WlKZ1/aQVr9ZKj8hRVbZLQr3oPAz3p9JGLZ
         AJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=AdflbgU09DTS4cJSjPs01SPy5ofGEDxZ50QAZbd+nRw=;
        b=Ta5RtMztcghRS9fFvI+m4Q7rpBmxPpkLuHNorJrZNi8WebCUp/Ft8NvVtYrsG0w8JH
         3fTc0RdazYB4Cy5oNLFoyIladkJJMkhmvSpVjtwpA8pB7lUWLWe1R5ju2sYUn0BcnPi1
         BZ5M+sNFmbTO+3IGTxpZQb4EE4KBDhDKIttVN1uTP3E8Knf/tkeXZPXgG6dBJRTmvtmy
         t+Ck6U2QrvFOmqv2R+z7dR1eeILMPoPyp3lpdg1YvMIUIIGUBuiOqB31kmucB98X9RSd
         rPhLYRnLQb+ja/WGo9V95aIfEntT+Fws3UyqqBpnjZ7cOXUtYv4PG/z0yhZUv1PX4Ixe
         zZag==
X-Gm-Message-State: AOAM532bcb4NmxSFuZiZgaJ1pkJwzAlMtUgvLN1X97R3BPedd51y3htY
        3BHD1RsywvbMcwfm+6qBsge5UMeO+GFFfMGowJun9hiGTuc=
X-Google-Smtp-Source: ABdhPJzydgx+vI8sm26fIsyp7p8wWxp/7+942nGph8gNxyfJ5V2IKYqCHbJcMxldk9skwbXAMJx8Eua4MDG8f0pT8Cw=
X-Received: by 2002:a2e:7114:: with SMTP id m20mr5164368ljc.229.1637128758331;
 Tue, 16 Nov 2021 21:59:18 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 16 Nov 2021 23:59:07 -0600
Message-ID: <CAH2r5mvZbUaWrLs8N2x2ELvOuoZk+Jeugeb72Kx6p8krwT4aHA@mail.gmail.com>
Subject: cifs: fix memory leak of smb3_fs_context_dup::server_hostname
To:     Stable <stable@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please include "cifs: fix memory leak of smb3_fs_context_dup::server_hostname"
Commit id:
869da64d071142d4ed562a3e909deb18e4e72c4e

It fixes a problem found with additional testing of:
commit 7be3248f3139 ("cifs: To match file servers, make sure the
server hostname matches") which was marked for stable.

-- 
Thanks,

Steve
