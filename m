Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FCD3ED8EE
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 16:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhHPO1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 10:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231928AbhHPO1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 10:27:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB50D60EAF;
        Mon, 16 Aug 2021 14:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629123989;
        bh=hEf8gUNvtrI0Snon9PPoc2Wz1SdOjDyhAeXAp4gLGIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PdRfY8aIVatlPCtSAE3sjZFx19V9oon5xI+KZ5lt1DJgX3qIuuM2/oH9sFBbFBb0T
         IIvFfDjOfT3xMBS+ztgP4Gd4jA+qwfZR5epVYFQTusVUE3z5kzqAHsv7hZNk2IMV0Y
         P+YOlmQKsk9FED4njnDfMtpvGy4YeVF7Y4HfJK8k=
Date:   Mon, 16 Aug 2021 16:26:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 4.14.y] KVM: nSVM: always intercept VMLOAD/VMSAVE when
 nested (CVE-2021-3656)
Message-ID: <YRp1kmNV1i3Hds/U@kroah.com>
References: <20210816140240.11399-8-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816140240.11399-8-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 04:02:36PM +0200, Paolo Bonzini wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> [ upstream commit c7dfa4009965a9b2d7b329ee970eb8da0d32f0bc ]

This is not a commit in Linus's tree :(
