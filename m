Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDD01565C8
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 18:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgBHRwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 12:52:21 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39498 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbgBHRwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 12:52:21 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so2596499wrt.6
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 09:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=DqpCN4mwV1fJ7BO/6WTSmefkazvsPWDu7aK1gQ4EsT8=;
        b=tdTSC4UNbUpEMpGLXqJMOEEB08pmsCNfo00GlDSvqvQSL9OqJJKydxhf6yHZLB+q5E
         9JQ+SPfTgbLuu/HxcgKwuBXM6fM0RT0WwjmNyVS5e1x4Ro7Db5f4D9AmYcSaSf6zrkOk
         jc7fKwChHSvDuDLRqDHHawLB74ZJQYYK1ctlB8JDGRVAfwod13nyOFvdXqUHUb9gMxPS
         naNSuji21CsZ3yPVvvpXhBV6tmZSJUzCTOAigSty1RKmaQZvGldthc3abVG1abcA5tac
         Tys0pjtsEH0Mof3rLbunTydmqS29xY2s6PlLiHRKSCMnrQuxlCCbNWPQIx2ujR10vw9l
         YSwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=DqpCN4mwV1fJ7BO/6WTSmefkazvsPWDu7aK1gQ4EsT8=;
        b=oG9s1fzr/kw10EmDwlcMPo7VWVdapQM2d6yO4tidcRXBCjNQj/Gqdb5SftZ8JlFe/m
         jmmHsuosY/JeHYudjgPWEYB5h+zC8DfvtpnkwxNemRBd3WCP3cJBVI7B41D311OYALrI
         7iVbtqKQDHPBc5bjWVQ90byf1Au0Ez9HGSPoz12HHhM/ZHxkTriqt9h1Ibz1pMSBeszZ
         2/qEEHelF+rO/yowdRg1R6iGDNkmI0TjJxfMGhvxZiTWrawMnanna5vdJDhhCB5BcYhA
         EnaM7q/8pY8mfDtjsVNvcJIRmXMBdO+w9Tkdx6lw2EXqxPSj6ROdGg8Z/rIV8e0Cgx5W
         8qrg==
X-Gm-Message-State: APjAAAXChJqT2kYTdQ2svOyA4x/vlH0dHmKxEnYtN+ax0XVcBe1lsT7r
        f4XX+gkl7IL8swllbDZ/nhpNOwPcKFG+nK2efdYdFg==
X-Google-Smtp-Source: APXvYqyQ7Dhv5Y76auNpEWM7JP59ok3TGYyfEV0VdHfzexulz9xxw3vluTR7aAYa+Js/hT3W+zzuHJKzcR9erk4DkEI=
X-Received: by 2002:a5d:6709:: with SMTP id o9mr4440905wru.82.1581184339382;
 Sat, 08 Feb 2020 09:52:19 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a1c:a94e:0:0:0:0:0 with HTTP; Sat, 8 Feb 2020 09:52:18 -0800 (PST)
Reply-To: corrinc492@gmail.com
From:   Corrin Campbell <corrinc728@gmail.com>
Date:   Sat, 8 Feb 2020 17:52:18 +0000
Message-ID: <CAPs+RyitDOAB+Y26aUr4Hrj5Mj72+i__obDWQtEFkvviJ3tgfg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG/CoERlYXIsDQpNecKgbmFtZcKgaXPCoENvcnJpbizCoEnCoGFtwqBhwqBVbml0ZWTCoFN0
YXRlc8KgYW5kwqBhwqBtaWxpdGFyecKgd29tYW7CoG5ldmVyDQptYXJyaWVkwqBub8Kga2lkc8Kg
eWV0LsKgScKgY2FtZcKgYWNyb3NzwqB5b3VywqBwcm9maWxlLMKgYW5kwqBJwqBwZXJzb25hbGx5
wqB0b29rDQppbnRlcmVzdMKgaW7CoGJlaW5nwqB5b3VywqBmcmllbmQuwqBGb3LCoGNvbmZpZGVu
dGlhbMKgbWF0dGVycyzCoHBsZWFzZQ0KY29udGFjdMKgbWXCoGJhY2vCoHRocm91Z2jCoG15wqBw
cml2YXRlwqBlbWFpbMKgY29ycmluYzQ5MkBnbWFpbC5jb23CoHRvDQplbmFibGXCoG1lwqBzZW5k
wqB5b3XCoG15wqBwaWN0dXJlc8KgYW5kwqBnaXZlwqB5b3XCoG1vcmXCoGRldGFpbHPCoGFib3V0
wqBtZS4NCkhvcGluZ8KgdG/CoGhlYXLCoGZyb23CoHlvdcKgc29vbi4NClJlZ2FyZHMNCkNvcnJp
bi4NCg==
