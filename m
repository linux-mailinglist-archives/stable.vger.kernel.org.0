Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EC223D952
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 12:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgHFKke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 06:40:34 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33149 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729365AbgHFKhW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 06:37:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 411705C0075;
        Thu,  6 Aug 2020 06:25:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 06 Aug 2020 06:25:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=y6TR7KGEsyJS9Ciixjf+CKxcF1U
        s1gifm6+rZFueTCc=; b=JLPR1zeUqCpKCuFq5tvi9FwyDVMN3SP6lh0ZxnXc86K
        Px+ydSiegQXOiWaURVko5RD3zRgobli4eXaWcSsJj1SzZVpZgcjcr3X0XElN99Jl
        wWJxA+blX7NSGhqTdFur1KtbiMXqYvdgaFHxoA65J1Ib/QzLelV6znMcO9bB4M3Q
        8gL1Vs5vWDhAnICQebEuMVOncR+O2RFP/5AtxqKOEKHCb5bqDXwx9HBAAkukqP73
        FkcomJxY0uOys9QkiRFO/S4+Zq6attAG9zgZUUKrlpswVAnbVxpOiPBmfnfvClbT
        ++NyT68hzPM6jlGGVr6IRDK0RBXPyimr8qflsKtWsmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=y6TR7K
        GEsyJS9Ciixjf+CKxcF1Us1gifm6+rZFueTCc=; b=pBgJV/EQoDtF0c8HkVFuZx
        2mSNZVeegWhXEuhu0JmsMVOEpxsfmJhcIauw0YiwzgMSQ62wUgqZZpHvFjT8cMbD
        rVKLAoc31qolZQVWe3YM/RElqYFjQ7+1cJQERNFwq3pDWqxhJEEsTKfj+VYRr8T1
        msa2B6/IFodhiA+Vb4rb1S/jDgpfJ2COl1ZiqyvwrcsRs6qYJ4sCv/cKRIcHd1RP
        HOcQDHXRXbFtO9Y67bKOPfB6NasLcGcYl7iBdbUUU6AQJKLBuNRTn5lnZv6M/cFg
        uhc9AHxdv2PSDjJ0WeP6herDeLddH65i3xm4g4ejZl94eJqwXRK31xTF+yaOVgAw
        ==
X-ME-Sender: <xms:fdorX8ncEe2zZKAa-CXAcFUlV3idhBK6dwZLu5KLEVXpcqvKc7vfLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkedtgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:fdorX72zORz44DIzvn5fVl__DWkmtAgoci9Rxm6_4H64BP56HBpc5g>
    <xmx:fdorX6qtqWsdvS-aswrdBnSsBk6Zg1cktQaxxT-lnNyQKIGljuc3lA>
    <xmx:fdorX4kZ4RJxNxh-Q6duf2lCox8toYVIQdQ7rwZzdYCqgCTyy32fkg>
    <xmx:ftorX2-kZAn2ievVuHPQP5KS3t9MgSO9HGBuKMI_ZpDZYrTYvNnnCg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D5C5530600B4;
        Thu,  6 Aug 2020 06:25:00 -0400 (EDT)
Date:   Thu, 6 Aug 2020 12:24:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Jiang Ying <jiangying8582@126.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        jack@suse.cz, stable@vger.kernel.org, wanglong19@meituan.com,
        heguanjun@meituan.com
Subject: Re: [PATCH v5] ext4: fix direct I/O read error for kernel stable
 rc4.4
Message-ID: <20200806102446.GA2792131@kroah.com>
References: <1596706691-82760-1-git-send-email-jiangying8582@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596706691-82760-1-git-send-email-jiangying8582@126.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 06, 2020 at 05:38:11PM +0800, Jiang Ying wrote:
> This patch is used to fix ext4 direct I/O read error when
> the read size is not aligned with block size.
> 
> Then, I will use a test to explain the error.
> 
> (1) Make a file that is not aligned with block size:
> 	$dd if=/dev/zero of=./test.jar bs=1000 count=3
> 
> (2) I wrote a source file named "direct_io_read_file.c" as following:
> 
> 	#include <stdio.h>
> 	#include <stdlib.h>
> 	#include <unistd.h>
> 	#include <sys/file.h>
> 	#include <sys/types.h>
> 	#include <sys/stat.h>
> 	#include <string.h>
> 	#define BUF_SIZE 1024
> 
> 	int main()
> 	{
> 		int fd;
> 		int ret;
> 
> 		unsigned char *buf;
> 		ret = posix_memalign((void **)&buf, 512, BUF_SIZE);
> 		if (ret) {
> 			perror("posix_memalign failed");
> 			exit(1);
> 		}
> 		fd = open("./test.jar", O_RDONLY | O_DIRECT, 0755);
> 		if (fd < 0){
> 			perror("open ./test.jar failed");
> 			exit(1);
> 		}
> 
> 		do {
> 			ret = read(fd, buf, BUF_SIZE);
> 			printf("ret=%d\n",ret);
> 			if (ret < 0) {
> 				perror("write test.jar failed");
> 			}
> 		} while (ret > 0);
> 
> 		free(buf);
> 		close(fd);
> 	}
> 
> (3) Compile the source file:
> 	$gcc direct_io_read_file.c -D_GNU_SOURCE
> 
> (4) Run the test program:
> 	$./a.out
> 
> 	The result is as following:
> 	ret=1024
> 	ret=1024
> 	ret=952
> 	ret=-1
> 	write test.jar failed: Invalid argument.
> 
> I have tested this program on XFS filesystem, XFS does not have
> this problem, because XFS use iomap_dio_rw() to do direct I/O
> read. And the comparing between read offset and file size is done
> in iomap_dio_rw(), the code is as following:
> 
> 	if (pos < size) {
> 		retval = filemap_write_and_wait_range(mapping, pos,
> 				pos + iov_length(iov, nr_segs) - 1);
> 
> 		if (!retval) {
> 			retval = mapping->a_ops->direct_IO(READ, iocb,
> 						iov, pos, nr_segs);
> 		}
> 		...
> 	}
> 
> ...only when "pos < size", direct I/O can be done, or 0 will be return.
> 
> I have tested the fix patch on Ext4, it is up to the mustard of
> EINVAL in man2(read) as following:
> 	#include <unistd.h>
> 	ssize_t read(int fd, void *buf, size_t count);
> 
> 	EINVAL
> 		fd is attached to an object which is unsuitable for reading;
> 		or the file was opened with the O_DIRECT flag, and either the
> 		address specified in buf, the value specified in count, or the
> 		current file offset is not suitably aligned.
> 
> So I think this patch can be applied to fix ext4 direct I/O error.
> 
> However Ext4 introduces direct I/O read using iomap infrastructure
> on kernel 5.5, the patch is commit <b1b4705d54ab>
> ("ext4: introduce direct I/O read using iomap infrastructure"),
> then Ext4 will be the same as XFS, they all use iomap_dio_rw() to do direct
> I/O read. So this problem does not exist on kernel 5.5 for Ext4.
> 
> >From above description, we can see this problem exists on all the kernel
> versions between kernel 3.14 and kernel 5.4. It will cause the Applications
> to fail to read. For example, when the search service downloads a new full
> index file, the search engine is loading the previous index file and is
> processing the search request, it can not use buffer io that may squeeze
> the previous index file in use from pagecache, so the serch service must
> use direct I/O read.
> 
> Please apply this patch on these kernel versions, or please use the method
> on kernel 5.5 to fix this problem.
> 
> Fixes: 9fe55eea7e4b ("Fix race when checking i_size on direct i/o read")
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Wang Long <wanglong19@meituan.com>
> Signed-off-by: Jiang Ying <jiangying8582@126.com>
> 
> Changes since V4:
> 	Fix build error on kernel stable rc 4.4.
> 	This patch only for kernel 4.4.

What about for the 4.9.y tree, will this work there too?

thanks,

greg k-h
