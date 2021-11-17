Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954B6454DDB
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 20:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240477AbhKQTbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 14:31:03 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:39690 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240484AbhKQTa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 14:30:57 -0500
Received: by mail-oi1-f171.google.com with SMTP id bf8so8653937oib.6
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 11:27:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=4zR+RBqMppddldx1ndt6CmUISY3RYtRtHi1YRkA5dRs=;
        b=ihzwb1Mp9FoUtxM+hhknhWIO9aui04Z4piaAOrZwC/bND1DpHIedGKi+AcOZNoOlqY
         VqpgpB84UutON1LxFzB3XxnQpO6LjUIVKCRXv0eMdnEl9qRjgSSdwqCm/R4QCPOKujcK
         tH7tMrL7yqNUw41+3Z99ICGMeQvlMMAYzLqqN9qbdwF8FR3p9WBujaqB0bsmKg58QZh3
         uOGFfnx0Lq6eJ6G3V1WhEN6+W/gQZ+7shzZ4kbGJASGv44gj5ZtBRMN8+D6jG/7agrzt
         mhNP5BNywSFUs537etEv3qxarL48jzzy0jsJi+eWCzQTyrJiMBAFmfJYXtfX3/cvWzPz
         aDjg==
X-Gm-Message-State: AOAM532o8W+yhSCa8VnY6p3/v1LJLWP85bIBz1O397bWowAqPJrcD4Ba
        /KqKa6/3bTBhwmy91mwBuxu2/yHIwA3q2eHKjJWICg4IIz8=
X-Google-Smtp-Source: ABdhPJwHXOa28xrzBhttGE5tvrADUmcug3RvisSlRNTatey01fcGUEI7m8pb0ZWJ2Tsv9vfkxjLdcI9h8Er69SzrE/Q=
X-Received: by 2002:a05:6808:14c3:: with SMTP id f3mr2102533oiw.51.1637177278479;
 Wed, 17 Nov 2021 11:27:58 -0800 (PST)
MIME-Version: 1.0
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 17 Nov 2021 20:27:47 +0100
Message-ID: <CAJZ5v0hXOYk4=hH_tgi8H-h1gJRsxB8znHgyah_SdiO68Kz+-w@mail.gmail.com>
Subject: Inclusion request for mainline commit d3c4b6f64ad356c0d9ddbcf73fa471e6a841cc5c
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg et al,

Please include the following mainline commit:

commit d3c4b6f64ad356c0d9ddbcf73fa471e6a841cc5c
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Wed Sep 29 18:31:25 2021 +0200

   ACPICA: Avoid evaluating methods too early during system resume

into all applicable -stable series.

It fixes resume from suspend-to-RAM on multiple systems.

Thanks!
