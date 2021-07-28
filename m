Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FF43D939F
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 18:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhG1Qyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 12:54:44 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:33759 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhG1Qyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 12:54:44 -0400
Received: by mail-ot1-f52.google.com with SMTP id 61-20020a9d0d430000b02903eabfc221a9so2815802oti.0;
        Wed, 28 Jul 2021 09:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0PgNZ436M2jw8/FCjILyCZri/MUE2bro2uDvxBo2jlU=;
        b=nD+X8nHscVKFiFvYklIyUDw4hquwkKXVUoRJUDu+CSFtoEeoSNck4RLI4r8WKEplUC
         gvQjg1Nd55ek0mOeorzpjoTrcD2LgkrKS9bl9tkwNQuricsMfV3CRywnIhkDHcV+NfC4
         /I+io1rL1bM6VyMmv9Gs20br+F0DmfpIBJ4fnxCKkdiz8zzylm4qDJgwlygKrp+QIC3e
         xb7/8SJsDYzGeYIANFLEDYTvOB5jZyc7EnHCf7EKm832x7JyOFUikcX/QRhH8arm77fi
         j2/3PKcU5B82R5r+X1bFxM/NlfO37NTSdU7Rj+VuOVhMM1E5WjCNLjkZAI1+CP5VxE3p
         lgxQ==
X-Gm-Message-State: AOAM530D7/xEkFigo+UAfNhVmvgYAaEV3MG1AnJ4jzjZ3NryaMwcnzoi
        jwNYwhsQKkIcbwuWOrBaPHS0m0XQjrfzK6KvmDk=
X-Google-Smtp-Source: ABdhPJzQppdx6fA1DUfutvjdx1AxsGLtON8pEhx1sa4xp4BPtxjOplcOzCofquN8IUn+qKNCCTrxfxt0O0pj66Jtk/w=
X-Received: by 2002:a9d:2968:: with SMTP id d95mr693275otb.321.1627491280620;
 Wed, 28 Jul 2021 09:54:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210728151958.15205-1-hui.wang@canonical.com>
 <YQGA4Kj2Imz44D3k@kroah.com> <CAJZ5v0iKTXSHRU96_xjnh4Zjh4gNfwZs9PusrX3OA059HJNHsw@mail.gmail.com>
 <a27b6363-e8d3-f9ad-5029-a4a434c6d79b@gmail.com>
In-Reply-To: <a27b6363-e8d3-f9ad-5029-a4a434c6d79b@gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 28 Jul 2021 18:54:29 +0200
Message-ID: <CAJZ5v0hkXcouTpF0Hmv9jUwHytOZRz0-T3TYGwzodT0EJYqRjw@mail.gmail.com>
Subject: Re: [PATCH] Revert "ACPI: resources: Add checks for ACPI IRQ override"
To:     PGNet Dev <pgnet.dev@gmail.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hui Wang <hui.wang@canonical.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Stable <stable@vger.kernel.org>, manuelkrause@netscape.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 6:50 PM PGNet Dev <pgnet.dev@gmail.com> wrote:
>
> On 7/28/21 12:38 PM, Rafael J. Wysocki wrote:
> > On Wed, Jul 28, 2021 at 6:08 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > Applied as 5.14-rc material, thanks!
>
> ty!
>
> Will this revert be auto-magically backported to earlier stable (5.12x/5.13x) trees?

It carries the Cc:stable tag, so it should be picked up automatically.

> Or does that require a manual trigger?
> Or, is that a distro kernel release issue?
>
