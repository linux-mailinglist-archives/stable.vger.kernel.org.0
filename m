Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51394316E46
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 19:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbhBJSQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 13:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbhBJSOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 13:14:50 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD2DC061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 10:14:08 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id n201so2862543iod.12
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 10:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=YkfrmKbF7XnzW4dDiG3AQxczI4wWFp9SvxeRYcwl4Z8=;
        b=TAxJ38CHkdwzbn/p5VsQ9zyWie58mMJee0l+dLPpDoQnEgltuKAoHjNZTsrT4x8XEO
         O8/Ax3MESrt4pSuTdseSeh4uIUyBEBcAlMaP1K3Exb44hruHdieCb8sLbRrTt8fOfT9n
         wnGNFLZvkmW3RQMK9zuT6Inxsg21EtOVxF31M/1mF9RiiuNG2nX9r6Fz8u0aIYYTLe4L
         9svy6URDj7DS5Xf0XuNs29KL6hGwabZubhbxQgoWn0z3t9r+zzDhbCOi2+OxfZgtNUyy
         96cfac71EayRYC7Z62VcMqwPPZP1WGFDkqKKaZwF2emJoH4MppviRf0zaQitwnN3z+9T
         vsKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=YkfrmKbF7XnzW4dDiG3AQxczI4wWFp9SvxeRYcwl4Z8=;
        b=YU76ETLGIGVVqSq0mL+DKb4GalIaTiP9vYVLA2ZIwd5O67P+LGqU1AI6iBRPuBxsls
         kdFfiDD0KKFwWb/nxBUfhfuqTP7PsKhk09sfwitYZCDmcu5+ZLEs9JEJFeDAN0SBM/YM
         FQ68Pb1ZmSoWZlnd3HNN/OIH6bkzp8J3nl/ildF4ER4M1fwA9/0Z44LSX7W9aF0lZsXu
         lM0lf4EQzz3HGetnDVLGbWdyDmBnIUOxxjau4gzIbmVq6tDMS4mZ9v2srHWltgw7M7Mm
         28jYn+DN1RzIxWA5iHdDr/7RAOgo6zhVXbwoGeZ4IaxQVGd++ffHVtqQTcACP3MvR5T0
         uFcw==
X-Gm-Message-State: AOAM531BMN0cMhVhaCD/tBjXIbOHL4gg6d35orNIpgnoXbkaIXJoueB0
        DQPB4ntp7vtrum5b/b2KScq1ISC5samA2zF3S9A=
X-Google-Smtp-Source: ABdhPJxcSC+D9fR1rbydvlQoZuj4xUfBdt26cdrB6C0Y6nHBtoG+55eX6dol713I2maPmYXIyZPkHYB8QRS6je1RXl8=
X-Received: by 2002:a6b:680e:: with SMTP id d14mr1993323ioc.74.1612980847834;
 Wed, 10 Feb 2021 10:14:07 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a02:a914:0:0:0:0:0 with HTTP; Wed, 10 Feb 2021 10:14:07
 -0800 (PST)
From:   KS JOHNSON BABU <ksjohnson456@gmail.com>
Date:   Wed, 10 Feb 2021 18:14:07 +0000
Message-ID: <CAO9k3eoiu43pcYU+gqp++WSmSPX0WHeUNEFkvVM8PJ6+1oPnOA@mail.gmail.com>
Subject: =?UTF-8?Q?Nal=C3=A9havost?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VnlwYWTDoXRlIHphasOtbWF2xJsgYSByw6FkIHMgdsOhbWkgbmF2w6HFvsOtbSBwxZnDoXRlbHN0
dsOtLCBwcm9zw61tLCB1ZMSbbGVqdGUgc2kNCsSNYXMgYSBvZHBvdsSbenRlIG1pLCBhYnljaG9t
IHNlIGzDqXBlIHBvem5hbGksIG5hcGnFoXRlIG1pIGUtbWFpbGVtOw0KbmFuY3lhdzFAb3V0bG9v
ay5jb20gRMOta3kgYSBkb3Vmw6FtLCDFvmUgc2kgb2QgdsOhcyBicnp5IHDFmWXEjXR1Lg0K
