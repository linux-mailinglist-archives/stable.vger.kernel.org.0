Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05A526C431
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 17:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgIPP3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 11:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIPP2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 11:28:51 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C61C02C28F
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 08:19:58 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id t12so6849999ilh.3
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 08:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VNB6kO1NhT7pvOlSLoJjvFXwv7bNFNilhORr2T8SlFc=;
        b=kp7g7jY1QDVEQeMdv+NIso9Teq41fvqsYCVFs7/CTunkmLjnfRHPKwWY0M5BUB720Y
         DugE62iRJlrinoQuDztVCms5PsMhuMnzKvWH+wt4+XVmvU8KW8tI1kTyEZhwKN7VQDGk
         NURBRxaTmWZIYjg5oOPo81GfQQLEu8icV5hI8dIV4wnMTP+GXhbgUxQZaelBxJPm7eDF
         94Zq1V9ZZsZe54yt5rHLkWH6i83o0HkddZidiGNWMgvBTSKzbpYHzEy/EXFG6f3uFD/n
         E/aZf0lTFcc4tKX09ZWWry7DC/x7VTMWPh1MD5R+hka/bCcHFcKIYXvm3hT/ixJcmdRw
         RwTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VNB6kO1NhT7pvOlSLoJjvFXwv7bNFNilhORr2T8SlFc=;
        b=CB5mCEhwvx8bx098/bwozVBV61WxyeHJxt4Ap5um6eohoEQ52B1hcc46iLGxZTQDrQ
         C1KcGE1MZcX4AXP2Ymnim5DoGS75GvWNRChU9BLRlMNxtzhi0URSzwpJKQjkxXlX+MZs
         xq75P0pm98LjT8cJ7IvZsLnvA8b5ylOFM7u8I8ZqsAJ0BeQaUJiOkaI2uPrcyopyJA0X
         AxnvrWZ5iO8m0IGXL6HkX+/WxZrBm03TnIqmWRSjzqgSL9ISezSsZXtYAn0JV0PlNkAS
         03xgYbn7F63r6xu6SihOwUNihMG4gU0V+OwC37oQt/mSvaY9y+9cAG6ZGcZfszEznXw0
         rpgw==
X-Gm-Message-State: AOAM530SFG74IojduJEkI8Xeko/Rl72MfqrHKgnnXgbCCYLeWEZ9uFv3
        zn5kWZ5mf1w9yMpc34oWlKlZXyEhUGlLMuv/o4M=
X-Google-Smtp-Source: ABdhPJx+HJRnE774t3/gUMU9tuNlkKaoWdIHZvEPLbZkCR+i0H9EzRNMz2UDRF38pM18k2ESI3ZHE+IAhiohTzKtZDc=
X-Received: by 2002:a92:d40c:: with SMTP id q12mr8746120ilm.169.1600269596379;
 Wed, 16 Sep 2020 08:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <CALW65jb8xv2tZPiimQcLHmpzcyhZG3t1HAZG_wdjE9sdXsQxPg@mail.gmail.com>
 <20200916093839.GB739330@kroah.com>
In-Reply-To: <20200916093839.GB739330@kroah.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 16 Sep 2020 23:19:44 +0800
Message-ID: <CALW65jZvq7_KggV4tOEi9=xFRjid1j+gfCSH7T3T_RSJCky_3g@mail.gmail.com>
Subject: Re: Please apply commit 1ed9ec9b08ad ("dsa: Allow forwarding of
 redirected IGMP traffic") to stable
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Daniel Mack <daniel@zonque.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 5:38 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> What stable tree(s) do you wish to see this applied to?

5.4.y and 4.19.y

>
> thanks,
>
> greg k-h
