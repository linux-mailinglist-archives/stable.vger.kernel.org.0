Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C077AF8BE
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 11:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfIKJUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 05:20:12 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39191 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfIKJUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 05:20:12 -0400
Received: by mail-ed1-f68.google.com with SMTP id u6so19961869edq.6;
        Wed, 11 Sep 2019 02:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xco/af/x6HLCOyTU+F8H8hS4JAyuU2ZOlKKdPNtbpTc=;
        b=IBQkqAd12yBtK7nUuezywmOLAhdKqEfDOGXS/rpxNGoG0SWhmCi0eQoQ+N5PpBj66G
         FwZSPnzD7gRissIkhDNBGvyI3qG+alfEf76ataezk8eiJD9hXs3qrFjFljsmBagnA00D
         AFM5P/MQtW30Lmier4a9FNH8sKnyjzAgu7leE52yCOe2+YPa5Z53PQMlVRwpFr8v7Mxs
         DQkxacEhzTs31k3OwYJQjn5IedecyueCd4zKrtNdKvDDFvbOe42eaAX2H5ggjUiJkaAO
         Zf6yjpC1B06wU2+AXCcxAZElwYkB+7XFbaHGf9XEGYeSHuVpd9vdo+hzHFB0YKnI71E3
         jpeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=xco/af/x6HLCOyTU+F8H8hS4JAyuU2ZOlKKdPNtbpTc=;
        b=ktL32IgkqMeBBNk8EJVAau+k/QRP17f2MPBv9r7kNvQB+GG5T4EnSiQ611u/3XzTTS
         Wkfb8wxFbzFLtzmYR6wnP5VxNuciWth/r4OGriMumGVIMgaLCa34dd9tHkxT6WXtWmzY
         0TCyYnQlO+FTwHauayM149mjeggW2+3+YOCkhQ70BpGJuztIqOHehaSfpdw8vFzw8Aqu
         O39AQ2lR6ozCLZER7MHzqzruSx0NpcBZXP1RQHbS3PaaI6bzTj+ptA6UbQ7PNQ+Buyqo
         FQNKUoCVKd/S73JiN63gxcp5JzkLktczoOTVyQNxpDzhE1gPvESVue71FsUELP88buYD
         jqaQ==
X-Gm-Message-State: APjAAAVsnOWaccbM1vmDwzU+c3ndnrIAVr9tcqzdHT3L0og0h7XEsccW
        KlAaCtfNlttoXtQbIDs3RIU=
X-Google-Smtp-Source: APXvYqy4BvSO0gG/4I1Sjsy9hAklRK2xOgW5m/CB7P/ljWkEEbYILxaBvColTBRBPjXu3ggDmikluA==
X-Received: by 2002:a50:eb4c:: with SMTP id z12mr35703111edp.155.1568193608578;
        Wed, 11 Sep 2019 02:20:08 -0700 (PDT)
Received: from dell5510 ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id l11sm157360ejn.62.2019.09.11.02.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 02:20:07 -0700 (PDT)
Date:   Wed, 11 Sep 2019 11:20:06 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Joey Pabalinas <joeypabalinas@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selftests/tpm2: Add the missing TEST_FILES assignment
Message-ID: <20190911092005.GA22492@dell5510>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20190910222523.8116-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910222523.8116-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jarkko,

> The Python files required by the selftests are not packaged because of
> the missing assignment to TEST_FILES. Add the assignment.

> Cc: stable@vger.kernel.org
> Fixes: 6ea3dfe1e073 ("selftests: add TPM 2.0 tests")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Reviewed-by: Petr Vorel <pvorel@suse.cz>

Kind regards,
Petr
